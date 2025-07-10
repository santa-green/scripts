"""creates a snapshot"""
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
    db_instance_identifier = 'db-instance-pg1'

    now = datetime.datetime.now()
    formatted_timestamp = now.strftime('%Y-%m-%d-%H-%M-%S')  # Example format
    snapshot_identifier = f'automated-snapshot-{formatted_timestamp}'

    try:
        # Create a temporary RDS snapshot
        response = rds_client.create_db_snapshot(
            DBInstanceIdentifier=db_instance_identifier,
            DBSnapshotIdentifier=f"{snapshot_identifier}-temp"
        )
        snapshot_arn = response['DBSnapshot']['DBSnapshotArn']
        print(snapshot_arn)
        snapshot_identifier = response['DBSnapshot']['DBSnapshotIdentifier']
        print(snapshot_identifier)
        print("[i] Snapshot creation started.")
    except ClientError as e:
        print("[x] Error creating snapshot:", e)

    return snapshot_arn, snapshot_identifier


if __name__ == '__main__':
    lambda_handler()
