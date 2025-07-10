"""creates a snapshot and stores it in an S3 bucket"""
import datetime
import time
import boto3
import os

from botocore.exceptions import ClientError

# root user
os.environ['AWS_ACCESS_KEY_ID'] = 'AKIATMYBHHBWFXMX3H4N'
os.environ['AWS_SECRET_ACCESS_KEY'] = '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'
os.environ['AWS_DEFAULT_REGION'] = 'eu-north-1'

def monitor_snapshot_creation(snapshot_identifier, rds_client, status_check_interval):
    """Monitors the status of an RDS snapshot creation until completion."""
    while True:
        response = rds_client.describe_db_snapshots(DBSnapshotIdentifier=snapshot_identifier)
        status = response['DBSnapshots'][0]['Status']
        if status.casefold() == 'available':
            print("[ok] Snapshot created successfully.")
            break
        elif status.casefold() in ('failed', 'deleted'):
            print(f"[x] Snapshot creation failed: {status}")
            raise RuntimeError(f"[x] Snapshot creation for {snapshot_identifier} failed.")
        else:
            current_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            print(f"[i] Snapshot creation still in progress: {status} - {current_time}")
            time.sleep(status_check_interval)


def monitor_export_task(task_identifier, rds_client, status_check_interval):
    """Monitors the status of an RDS export task until completion."""
    while True:
        response = rds_client.describe_export_tasks(ExportTaskIdentifier=task_identifier)
        print(response)
        status = response['ExportTasks'][0]['Status']
        print(status)
        if status.casefold() == 'complete':
            print("[ok] Export task completed successfully.")
            break
        elif status.casefold() in ('failed', 'cancelled'):
            print(f"[x] Export task failed: {status}")
            raise RuntimeError(f"[x] Export task {task_identifier} failed.")
        else:
            current_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            print(f"[i] Export task still in progress: {status} - {current_time}")
            time.sleep(status_check_interval)


def lambda_handler(event, context):
# def lambda_handler():
    rds_client = boto3.client('rds')
    s3_client = boto3.client('s3')

    db_instance_identifier = 'db-instance-pg1'

    now = datetime.datetime.now()
    formatted_timestamp = now.strftime('%Y-%m-%d-%H-%M-%S')  # Example format
    snapshot_identifier = f'automated-snapshot-{formatted_timestamp}'

    try:
        # [1] Create a temporary RDS snapshot
        response = rds_client.create_db_snapshot(
            DBInstanceIdentifier=db_instance_identifier,
            DBSnapshotIdentifier=f"{snapshot_identifier}-temp"
        )
        snapshot_arn = response['DBSnapshot']['DBSnapshotArn']
        snapshot_identifier = response['DBSnapshot']['DBSnapshotIdentifier']
        print("[1] Snapshot creation started. Monitoring progress...")
        monitor_snapshot_creation(snapshot_identifier, rds_client, 30)

        # [2] Initiate export task using the temporary snapshot
        # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/rds/client/start_export_task.html
        # snapshot_arn = 'arn:aws:rds:eu-north-1:233541417068:snapshot:automated-snapshot-2023-12-29-21-10-24-temp'
        response = rds_client.start_export_task(
            ExportTaskIdentifier=snapshot_identifier,
            SourceArn=snapshot_arn,
            S3BucketName='rds-snapshots-kirl',
            S3Prefix=snapshot_identifier,
            IamRoleArn='arn:aws:iam::233541417068:role/service-role/snapshots-export-s3',
            KmsKeyId='de5a9073-934b-4699-8bee-8b44e9ff594f',
        )
        export_task_identifier = response['ExportTaskIdentifier']
        print("[2] Export task started. Monitoring progress...")
        monitor_export_task(export_task_identifier, rds_client, 30)

        print("Snapshot created and export task started successfully.")
    except ClientError as e:
        print("Error creating snapshot or starting export task:", e)

    # Remember to remove the temporary snapshot after the export finishes
    finally:
        # [3] delete the temporary snapshot
        print("[3] Delete snapshot task started. Monitoring progress...")
        rds_client.delete_db_snapshot(DBSnapshotIdentifier=f"{snapshot_identifier}")
        print("Temporary snapshot deleted.")


if __name__ == '__main__':
    lambda_handler({"key1": "value1","key2": "value2"}, None)