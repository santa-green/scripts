import pymysql


def lambda_handler(event, context):
    rds_host = "mysqlforlambda.cxbshdesgwgk.us-east-1.rds.amazonaws.com"  # Replace with your RDS endpoint
    username = "admin"  # Replace with your database username
    password = "mysql12345"  # Replace with your database password
    database_name = "ExampleDB"  # Replace with your database name

    conn = None
    try:
        conn = pymysql.connect(host=rds_host, user=username, password=password, database=database_name)
        cursor = conn.cursor()
        cursor.execute("SELECT VERSION()")
        result = cursor.fetchone()
        print("MySQL version:", result[0])
    except Exception as e:
        print("Error connecting to MySQL database:", e)
    finally:
        if conn:
            conn.close()

    return {
        "statusCode": 200,
        "body": "MySQL version retrieved successfully"
    }
