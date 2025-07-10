#!/bin/bash

# Variables
SECRET_NAME="rds!db-5e29bff3-d51c-4bd6-b38d-e6ca1fb5c8a5"
REGION="eu-north-1"

# Fetch credentials from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $REGION)

# Extracting the SecretString from the JSON response
# jq - tool for parsing and manipulating json; -r raw output
SECRET=$(echo $SECRET_JSON | jq -r '.SecretString')

# Parsing the SecretString JSON into variables
USERNAME=$(echo $SECRET | jq -r '.username')
PASSWORD=$(echo $SECRET | jq -r '.password')

# Database connection parameters
HOSTNAME="db-instance-pg1.c1nyoxqqdwsz.eu-north-1.rds.amazonaws.com"
PORT=5432
DATABASE="db_test_pg1"

# Printing the fetched credentials (for demonstration)
echo "Username: $USERNAME"
echo "Password: $PASSWORD"

# Performing database operations using fetched credentials (not feasible in Bash)
# This part cannot be directly translated to Bash, as Bash doesn't have native support for PostgreSQL queries
# Connecting to the database, executing queries, and managing connections is typically done using programming languages like Python

export PGPASSWORD=$PASSWORD;
psql -h $HOSTNAME -p $PORT -d $DATABASE -U $USERNAME -c 'SELECT version(); INSERT INTO test_s3_copy SELECT * FROM test_s3 WHERE id NOT IN (SELECT id FROM test_s3_copy);'
