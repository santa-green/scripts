import psycopg2
import boto3
from botocore.exceptions import ClientError
import json


def get_secret() -> str:
    """gets secret value from AWS Secrets Manager"""
    secret_name = "rds!db-5e29bff3-d51c-4bd6-b38d-e6ca1fb5c8a5"
    region_name = "eu-north-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    secret = get_secret_value_response['SecretString']
    return secret


def get_credentials() -> dict:
    """Returns the credentials dictionary"""
    credentials = get_secret()
    credentials_dict = json.loads(credentials)
    # Connection parameters
    hostname = "db-instance-pg1.c1nyoxqqdwsz.eu-north-1.rds.amazonaws.com"
    port = 5432
    database = "db_test_pg1"
    username = credentials_dict["username"]
    password = credentials_dict["password"]
    return {
        "hostname": hostname,
        "port": port,
        "database": database,
        "username": username,
        "password": password
    }


def sql_exec() -> None:
    """Executes the sql script"""
    try:
        credentials = get_credentials()
        connection = psycopg2.connect(
            # host=hostname,
            host=credentials["hostname"],
            port=credentials["port"],
            database=credentials["database"],
            user=credentials["username"],
            password=credentials["password"]
        )

        cursor = connection.cursor()
        cursor.execute("SELECT version();")
        record = cursor.fetchone()
        print("You are connected to - ", record, "\n")
        cursor.execute("INSERT INTO test_s3_copy SELECT * FROM test_s3 WHERE id NOT IN (SELECT id FROM test_s3_copy);")
        connection.commit()
        print("[i] Status: SUCCESS")

    except (psycopg2.OperationalError, psycopg2.ProgrammingError, psycopg2.IntegrityError,
            psycopg2.DataError, psycopg2.InterfaceError, psycopg2.InternalError) as error:
        print(f"Specific error: {error}")
        print("Error while working with PostgreSQL", error)
        print("[x] Status: FAILURE")
        connection.rollback()

    finally:
        # Close the cursor and connection
        if connection:
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")


if __name__ == '__main__':
    sql_exec()