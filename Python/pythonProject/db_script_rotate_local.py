"""Rotates the secret value from your local machine"""
import boto3
import base64
from botocore.exceptions import ClientError
import secrets  # provides functions for generating cryptographically strong random numbers.
import string  # contains constants of ASCII characters, like uppercase letters,
# lowercase letters, digits, and punctuation.
import os

# Set AWS credentials as environment variables (replace these with your actual credentials)
# michael.jackson
# os.environ['AWS_ACCESS_KEY_ID'] = 'AKIAT*********TW6M'
# os.environ['AWS_SECRET_ACCESS_KEY'] = '8JU4cb4FUd***********S/+KfGxEYEGtOq/Up+RYZ'
# root user
os.environ['AWS_ACCESS_KEY_ID'] = 'AKIATM********3H4N'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'DEONZeTkfE*************rxrxVX8C6uMWRG'


def lambda_handler(event, context):

    secret_name = event['SecretId']
    print(secret_name)  # check
    region_name = event['Region']
    print(region_name) # check

    session = boto3.session.Session()
    print(session)  # check
    client = session.client(service_name='secretsmanager', region_name=region_name)
    print(f"client: {client}")  # check

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        print(f"get_secret_value_response => {get_secret_value_response}")  # check
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceNotFoundException':
            print("The requested secret " + secret_name + " was not found")
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            print("The request was invalid due to:", e)
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            print("The request had invalid params:", e)
    else:
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            secret = base64.b64decode(get_secret_value_response['SecretBinary'])

        # Generate a new secret using your preferred method
        new_secret = generate_new_secret()  # Replace with your secret generation logic

        try:
            response = client.update_secret(SecretId=secret_name, SecretString=new_secret)
            print(f"Successfully rotated secret: {secret_name} - {new_secret}")
        except ClientError as e:
            print("Failed to rotate secret:", e)


def generate_new_secret():
    """Generate a new secret using your preferred method"""
    # Generate a new secret using your preferred method
    return str({"password": generate_password()})


def generate_password(length=12):
    alphabet = string.ascii_letters + string.digits + string.punctuation
    # print(alphabet)
    password = '*'.join(secrets.choice(alphabet) for _ in range(length))
    password_extra = f"NiX{password}pg_kirl"
    return password_extra


if __name__ == '__main__':
    lambda_handler({"SecretId": "pg_rotate_secret", "Region": "eu-north-1"}, None)
    # print(generate_password())
    # print(generate_new_secret())
