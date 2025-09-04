"""This job is used to re-generate data lake based on existing full load data, produced by DMS.

RECOMMENDED CONFIGURATION:
    1) 10x workers of G.1X type, considering potentially vast tables on production.
    2) Configure number of partitions based on the table sizes.
    As a rule of thumb, each partition should have 100-200MB of data.
"""
import json
import logging
import sys
from functools import reduce

import boto3
from pyspark.sql import functions as f, types as t, DataFrame
from pyspark.sql.context import SparkContext
from awsglue.context import GlueContext
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions


ARGS = getResolvedOptions(sys.argv, [
    'JOB_NAME', 'INPUT_BUCKET_NAME', 'PATH_TO_FULL_DATA', 'NUM_PARTITIONS',
    'OUTPUT_BUCKET_NAME', 'DB_NAME', 'SECRET_NAME', 'SECRET_KEY_NAME'
])
NUM_PARTITIONS = int(ARGS['NUM_PARTITIONS'])
INPUT_BUCKET_NAME = ARGS['INPUT_BUCKET_NAME']
OUTPUT_BUCKET_NAME = ARGS['OUTPUT_BUCKET_NAME']
PATH_TO_FULL_DATA = ARGS['PATH_TO_FULL_DATA']
SECRET_NAME = ARGS['SECRET_NAME']
SECRET_KEY_NAME = ARGS['SECRET_KEY_NAME']
DB_NAME = ARGS['DB_NAME']
S3_WAREHOUSE = f's3://{OUTPUT_BUCKET_NAME}/{DB_NAME}/'

glueContext = GlueContext(SparkContext.getOrCreate())
spark = glueContext.spark_session

spark.conf.set("spark.sql.catalog.glue_catalog", "org.apache.iceberg.spark.SparkCatalog")
spark.conf.set("spark.sql.catalog.glue_catalog.warehouse", S3_WAREHOUSE)
spark.conf.set("spark.sql.catalog.glue_catalog.catalog-impl", "org.apache.iceberg.aws.glue.GlueCatalog")
spark.conf.set("spark.sql.catalog.glue_catalog.io-impl", "org.apache.iceberg.aws.s3.S3FileIO")
spark.conf.set("spark.sql.shuffle.partitions", "1000")

# Logging setup
MSG_FORMAT = '%(asctime)s %(levelname)s: %(message)s'
DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S'
logging.basicConfig(format=MSG_FORMAT, datefmt=DATETIME_FORMAT)
logger = logging.getLogger("full_load")
console_handler = logging.StreamHandler(sys.stdout)
logger.setLevel(logging.DEBUG)
logger.addHandler(console_handler)


s3 = boto3.client("s3")

PII_MAPPING = {
    'Absence_Request': [
        'ABSR_Notes', 'ABSR_NotesToAdmin', 'ABSR_NotesAdminOnly',
        'WORK_ID', 'SUB_ID', 'ABSR_User', 'Absr_ApproverKey',
        'LastChgImpersonatorFlId',
    ],
    'Absence_Request_Attachments': ['FA_ID'],
    'AbsenceUsageTracking': ['AbsenceReasonId'],
    'Allegheny_Accruals': ['AACC_Illness'],
    'Absence_Log': ['ABSL_User', 'LastChgImpersonatorFlId'],
    'AbsenceRequest_ApprovalComments': ['ARAC_UserKey', 'ARAC_Message', 'LastChgImpersonatorFlId'],
    'AbsenceFeedback': ['SUB_ID', 'WORK_ID'],
    'AbsenceFeedBackAnswers': ['AFA_Response'],
    'avail_subs_shamong': ['SUB_SSNum', 'SUB_PIN', 'SUB_LastName', 'SUB_FirstName',
                           'SUB_Middle', 'SUB_Phone', 'SUB_Email'],
    'Available_to_Call': ['SUB_ID', 'LastChgImpersonatorFlId'],
    'BadLogins': ['UserId', 'LastIP'],
    'Billing_Header': ['BLHD_FirstName', 'BLHD_Middle', 'BLHD_LastName', 'BLHD_Name'],
    'Contact_Info': ['ci_firstName', 'ci_middleName', 'ci_lastname','ci_phone', 'ci_fax', 'ci_email'],
    'CustomerServiceReps': ['CSR_FirstName', 'CSR_LastName', 'CSR_Email'],
    'Custom_FieldValue': ['cfv_value'],
    'Custom_FieldValueTab': [f'CFV_Value{i}' for i in range(1, 31)],
    'Disclaimer_Acceptance': ['ObjKey_ID', 'LastChgImpersonatorFlId'],
    'DistributionListMember': ['DISTM_UserKey', 'DISTM_OtherEmails'],
}


def get_secret_value(secret_name: str, key: str, region_name: str = "us-east-1") -> str:
    """Get the secret value from an SM's dictionary of key-value secrets.

    Args:
        secret_name (str): Name of the secret.
        key (str): Name of the key.
        region_name (str): Region name, defaults to N.Virginia

    Returns:
        str: Value of the secret.
    """
    client = boto3.client("secretsmanager", region_name=region_name)

    try:
        response = client.get_secret_value(SecretId=secret_name)
    except Exception as e:
        raise RuntimeError(f"Error retrieving secret '{secret_name}': {e}")

    secret = response["SecretString"]

    try:
        secret_dict = json.loads(secret)
        return secret_dict.get(key)
    except json.JSONDecodeError:
        raise ValueError(f"Secret '{secret_name}' is not JSON, cannot extract key '{key}'")


def list_s3_folders(bucket: str, prefix: str) -> list[str]:
    """
    List all folder names directly under the given bucket/prefix.
    Returns only the folder names (without the full prefix).
    Example:
        If bucket contains keys like "db1/table1/file.parquet", "db2/file.parquet"
        - list_s3_folders(bucket, "")      -> ["db1", "db2"]
        - list_s3_folders(bucket, "db1/") -> ["table1"]

    Args:
        bucket (str): Name of a bucket.
        prefix (str): Lookup prefix.
            By default, DMS creates files under the root folder of a bucket,
             so this argument is usually just a blank string.

    Returns:
        list[str]: List of target directories.
    """
    base = prefix + "/" if prefix and not prefix.endswith("/") else prefix

    logger.info(f"Looking for folders in s3://{bucket}/{base}")

    paginator = s3.get_paginator("list_objects_v2")
    result = []

    for page in paginator.paginate(Bucket=bucket, Prefix=base, Delimiter="/"):
        for cp in page.get("CommonPrefixes", []):
            folder_path = cp["Prefix"]
            folder_name = folder_path[len(base):].rstrip("/")
            result.append(folder_name)

    return result


def encrypt_columns(input_df: DataFrame, table_name: str) -> DataFrame:
    """Encrypt all PII/PHI columns in the given dataframe.
    If any column is missing - skip it and log a warning

    Args:
        input_df (DataFrame): Target DataFrame to encrypt.
        table_name (str):

    Returns:
        (DataFrame): Encrypted DF. The columns can be decrypted using AES algo and the key.
    """
    for col in PII_MAPPING[table_name]:
        if col in input_df.columns:
            logger.info(f'Encrypting col {col} for table {table_name}')
            input_df = input_df.withColumn(
                col,
                f.base64(
                    f.aes_encrypt(
                        input=f.col(col).cast(t.StringType()),
                        key=f.lit(encryption_key),
                    )
                )
            )
        else:
            logger.warning(f'Column {col} missing in table {table_name}, skipping encryption...')
    return input_df

if __name__ == '__main__':
    stripped_path = PATH_TO_FULL_DATA.strip()
    dbs = list_s3_folders(INPUT_BUCKET_NAME, stripped_path)
    logger.info(f"Found following dbs: {dbs}")
    dbs_tables = {
        db: list_s3_folders(INPUT_BUCKET_NAME, stripped_path + db) for db in dbs
    }
    total_tables = len(reduce(lambda x,y: x + y, dbs_tables.values()))

    processed = 0
    encryption_key = get_secret_value(SECRET_NAME, SECRET_KEY_NAME)
    for db, tables in dbs_tables.items():
        for table in tables:
            if table in PII_MAPPING:  # Temporary limiting condition
                full_path = f"s3://{INPUT_BUCKET_NAME}/{stripped_path}/{db}/{table}/"
                logger.info(f'Loading table {table} at {full_path}')
                df = spark.read.parquet(full_path).repartition(NUM_PARTITIONS)
                if table in PII_MAPPING:
                    df = encrypt_columns(df, table)
                df.createOrReplaceTempView("tmp_data")
                table = table.lower()

                if not spark._jsparkSession.catalog().tableExists(f"glue_catalog.{DB_NAME}.{table}"):
                    spark.sql(f"""
                        CREATE TABLE glue_catalog.{DB_NAME}.{table}
                        USING iceberg
                        AS SELECT * FROM tmp_data
                    """)
                else:
                    spark.sql(f"""
                        INSERT INTO glue_catalog.{DB_NAME}.{table}
                        SELECT * FROM tmp_data
                    """)
                processed += 1
                logger.info(f'Successfully wrote table {table}, {processed}/{total_tables} tables done')
