"""exports a snapshot to S3"""
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
    snapshot_arn = 'arn:aws:rds:us-east-1:064963113358:snapshot:automated-snapshot-2024-01-08-17-44-33-temp'

    try:
        # Export an RDS snapshot to S3
        # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/rds/client/start_export_task.html
        response = rds_client.start_export_task(
            ExportTaskIdentifier=snapshot_identifier,
            SourceArn=snapshot_arn,
            S3BucketName='rds-snapshots-kirl',
            S3Prefix=snapshot_identifier,
            IamRoleArn='arn:aws:iam::064963113358:role/RDSSnapshotExportToS3Role',
            KmsKeyId='ec367aed-327c-43a4-a854-d72267bc1e91',
        )
        export_task_identifier = response['ExportTaskIdentifier']
        print(export_task_identifier)
        print("[i] Export task started.")
    except ClientError as e:
        print("[x] Error exporting snapshot:", e)

    return snapshot_identifier


if __name__ == '__main__':
    lambda_handler()
