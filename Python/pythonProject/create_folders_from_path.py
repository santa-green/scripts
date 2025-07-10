# GENERAL IDEA:
# -- Step 1: connect to this table -> lpg.inline_asset_items_in_master_course_reader
# -- Step 2: [example] c:\Geyser\Discipline\ISBN\Type\asset_file_name.ext
# -- Step 3: create the folders' hierarchy


import pymysql
import os
import logging
import db_creds


# Database connection parameters
db_params = {
    'host': 'mindtap-preprod.czatb71a25k6.us-east-1.rds.amazonaws.com',
    'port': 3306,
    'database': 'lpg',
    'user': db_creds.DB_USER,
    'password': db_creds.DB_PASSWORD,
}


connection = pymysql.connect(**db_params)
print(connection)

# Configure logging
logging.basicConfig(filename='lpg_create_folders_history.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info(f"{f' Folder creation started... ':*^100}")
logging.critical(f"[ ! ] Make sure there's no confidential information in the log.")


def check_connection():
    """sql server connection check"""
    conn = None
    try:
        # conn = psycopg2.connect(host=rds_host, user=username, password=password, database=database_name)
        conn = pymysql.connect(host=db_params['host'], user=db_params['user'], password=db_params['password'],
                                database=db_params['database'])
        cursor = conn.cursor()
        cursor.execute("SELECT VERSION()")
        result = cursor.fetchone()
        logging.info(f"MySQL version:{result[0]}")
    except Exception as e:
        logging.error("[ x ] Error connecting to PostgreSQL database:", e)
    finally:
        if conn:
            conn.close()

    return {
        "statusCode": 200,
        "body": "[ i ] MySQL version retrieved successfully"
    }


def get_path() -> tuple:
    """getting the path from the table"""
    conn = pymysql.connect(host=db_params['host'], user=db_params['user'], password=db_params['password'],
                            database=db_params['database'])
    cursor = conn.cursor()
    cursor.execute("""select * from lpg.tmp_weekly_geyser_lpg_folders;""")
    path = cursor.fetchall()
    return path


def create_folders(path):
    # for i in range(len(path)):
    #     discipline = path[i][0]
    #     isbn = path[i][1]
    #     asset_type = path[i][2]

    for row in path:
        # discipline, isbn, asset_type = row
        # folder_path = os.path.join(core_folder, discipline, isbn, asset_type)
        # print(row)
        # print(row[0])
        folder_path = row[0]
        print(folder_path, type(folder_path))
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
            logging.info(f'[SUCCESS] Folder created at {folder_path}')
        else:
            logging.error(f'[DUPLICATE] Folder already exists at {folder_path}')


if __name__ == '__main__':
    check_connection()
    get_path()
    create_folders(get_path())

