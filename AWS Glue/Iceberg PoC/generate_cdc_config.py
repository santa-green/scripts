"""This job is used to re-create a CDC config, consisting of table-keys mappings.
This is later used to properly process CDC events (Updates/Deletes) by matching required unique rows.

RECOMMENDED CONFIGURATION:
    1) 2x workers of G.1X type, as this job is not memory-intensive.
"""

import json
import logging
import sys

import boto3
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from pyspark.sql import DataFrame
from awsglue.utils import getResolvedOptions

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
glue = boto3.client("glue")
ARGS = getResolvedOptions(sys.argv, [
    'JOB_NAME', 'CONNECTION_NAME', 'CDC_CONFIG_PATH',
    'SECRET_NAME',
])
CONNECTION_NAME = ARGS['CONNECTION_NAME']
CDC_CONFIG_PATH = ARGS['CDC_CONFIG_PATH']
SECRET_NAME = ARGS['SECRET_NAME']
# Logging setup
MSG_FORMAT = '%(asctime)s %(levelname)s: %(message)s'
DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S'
logging.basicConfig(format=MSG_FORMAT, datefmt=DATETIME_FORMAT)
logger = logging.getLogger("full_load")
console_handler = logging.StreamHandler(sys.stdout)
logger.setLevel(logging.DEBUG)
logger.addHandler(console_handler)

conn = glue.get_connection(Name=CONNECTION_NAME)["Connection"]

conn_props = conn["ConnectionProperties"]
jdbc_url = conn_props["JDBC_CONNECTION_URL"]
query = """
SELECT
    s.name as schema_name, 
	t.name as table_name,
	STRING_AGG(c.name, ',') as list_of_pks
FROM sys.schemas s
JOIN sys.tables t 
    ON t.schema_id = s.schema_id
LEFT JOIN sys.indexes i
	ON t.object_id = i.object_id
	AND i.is_primary_key = 1
LEFT JOIN sys.index_columns ic
	ON I.object_id = ic.object_id
	AND i.index_id = ic.index_id
LEFT JOIN sys.columns c 
	ON ic.object_id = c.object_id
	AND ic.column_id = c.column_id
WHERE s.name NOT IN ('sys', 'INFORMATION_SCHEMA')
GROUP BY s.name, t.name
"""

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


pks_df: DataFrame = (
    spark.read
    .format("jdbc")
    .option("url", jdbc_url)
    .option("dbtable", f"({query}) as a")
    .option("user", get_secret_value(SECRET_NAME, 'username'))
    .option("password", get_secret_value(SECRET_NAME, 'password'))
    .load()
)

pks_df.write.mode('overwrite').parquet(CDC_CONFIG_PATH)
