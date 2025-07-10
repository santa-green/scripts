"""deletes a snapshot from RDS"""
import datetime
import boto3
import os

from botocore.exceptions import ClientError

os.environ['AWS_ACCESS_KEY_ID'] = 'AKIAQ6IA2OGHKRLFMWPA'
os.environ['AWS_SECRET_ACCESS_KEY'] = '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'
os.environ['AWS_DEFAULT_REGION'] = 'us-east-1'


# def lambda_handler(event, context):
def lambda_handler():
    rds_client = boto3.client('rds')
    snapshot_identifier = 'automated-snapshot-2024-01-08-17-44-33-temp'

    try:
        rds_client.delete_db_snapshot(DBSnapshotIdentifier=f"{snapshot_identifier}")
        print("[i] Delete task started.")
    except ClientError as e:
        print("[x] Error deleting snapshot:", e)


if __name__ == '__main__':
    lambda_handler()
