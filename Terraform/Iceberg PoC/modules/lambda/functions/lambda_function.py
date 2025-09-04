import json
import os
import logging

import boto3

GLUE_JOB_NAME = os.getenv('GLUE_JOB_NAME')

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

s3_client = boto3.client('s3')
glue_client = boto3.client('glue')


def lambda_handler(event, context):
    detail = event["detail"]
    bucket_name = detail['bucket']['name']
    object_key = detail['object']['key']
    
    path = f's3://{bucket_name}/{object_key}'
    logger.info(f'New file created under {path} path.')

    glue_client.start_job_run(
        JobName=GLUE_JOB_NAME,
        Arguments={
            '--CDC_PATH': path
        }
    )
    logger.info(f"Glue job triggered for path {path}")

    return {
        'statusCode': 200,
        'body': 'Glue job triggered successfully.'
    }