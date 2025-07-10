import psycopg2
import logging

db_engine = 'postgres'
# db_engine = 'db2'
if db_engine == 'postgres':
    from sql_queries_postgres import *
elif db_engine == 'db2':
    from sql_queries_db2 import *

# Database connection parameters (for prod use aws secret/parameter store)
# region
params_db1 = {
    'host': 'localhost',
    'port': '5432',
    'database': 'dvdrental',
    'user': 'postgres',
    'password': 'p0$tgre$',
}
params_db2 = {
    'host': 'localhost',
    'port': '5432',
    'database': 'dvdrental_3',
    'user': 'postgres',
    'password': 'p0$tgre$',
}
# endregion
# Copy a DB for testing:
# CREATE DATABASE dvdrental3;
# pg_dump -h localhost -p 5432 -U postgres -d dvdrental -F c -f source_database.dump
# pg_restore -h localhost -p 5432 -U postgres -d dvdrental3 source_database.dump

schema_db1_info_object = {}
schema_db2_info_object = {}

# Configure logging
logging.basicConfig(filename='history.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info(f"{f' DB SCHEMAS COMPARISON STARTED... ':*^100}")
logging.info(f"{f' DB ENGINE - {db_engine}... ':*^100}")
logging.critical(f"[ ! ] Make sure there's no confidential information in the log.")


objects_list = ['tables', 'functions', 'procedures', 'db_triggers', 'table_triggers', 'types', 'indexes_pk', 'indexes', 'sequences',
                'tablespaces', 'roles', 'constraints', 'columns', 'schemas']


def get_schema_obj_info(db_params, schema_db_num, object_type) -> tuple:
    """creates a connection, and retrieves schema object information from the database for the specified object type"""
    try:
        # This error "UnicodeDecodeError: 'utf-8' codec can't decode byte 0xd4
        # in position 61: invalid continuation byte" means "wrong creds"
        connection = psycopg2.connect(**db_params)
        cursor = connection.cursor()
        return execute_cursor(cursor, schema_db_num, object_type)

    except (psycopg2.OperationalError, psycopg2.ProgrammingError,
            psycopg2.IntegrityError, psycopg2.DataError,
            psycopg2.InterfaceError, psycopg2.InternalError, UnicodeDecodeError) as error:
        logging.error("[x] Status: FAILURE. Error while working with the DB", error)
        logging.exception("EXCEPTION OCCURRED")
        if connection:
            connection.rollback()

    finally:
        # Close the cursor and connection
        if connection and object_type == objects_list[-1]:
            cursor.close()
            connection.close()
            message = f"[i] The DB connection to the DB '{db_params['database'].upper()}' is closed"
            logging.info(message)
            logging.info(f"{'...':=^100}\n")


def execute_cursor(cursor, schema_db_num, object_type) -> tuple:
    """executes sql queries (general + count) using the given cursor"""
    query = "sql_" + object_type
    query_function = globals().get(query)
    query_count = query + "_count"
    query_count_function = globals().get(query_count)

    cursor.execute(query_function)
    # fetchone returns a tuple, fetchall returns a list.
    record = cursor.fetchall()
    schema_db_num['schema_objects'] = record

    cursor.execute(query_count_function)
    records_count = cursor.fetchone()
    return records_count[0], object_type


def get_exclusive_values() -> tuple:
    """Compares 2 dictionaries and returns exclusive values, if any"""
    schema_list1 = [item[0] for item in schema_db1_info_object['schema_objects']]
    schema_list2 = [item[0] for item in schema_db2_info_object['schema_objects']]
    exclusive_values = set(schema_list1) ^ set(schema_list2)
    return exclusive_values, schema_list1, schema_list2


def display_exclusive_values(exclusive_values, objects_list, db_num) -> None:
    """Writes exclusive values to the log file"""
    exclusive_values_in_db = [value for value in exclusive_values if value in objects_list]
    logging.info(f"{f' DB{db_num} ':*^100}")
    logging.info(f"{obj1_info[1].upper()}")
    logging.info(f"[!] Objects found, totally: ")
    if db_num == 1:
        if obj1_info[0] == 0:
            logging.warning(obj1_info[0])
        else:
            logging.info(obj1_info[0])
    elif db_num == 2:
        if obj2_info[0] == 0:
            logging.warning(obj2_info[0])
        else:
            logging.info(obj2_info[0])
    logging.info('[i] Exclusive objects:')
    if not exclusive_values_in_db:
        logging.info('* not found *')
    else:
        for item in exclusive_values_in_db:
            logging.info(item)


if __name__ == "__main__":
    for i in range(len(objects_list)):
        obj1_info = get_schema_obj_info(params_db1, schema_db1_info_object, objects_list[i])
        obj2_info = get_schema_obj_info(params_db2, schema_db2_info_object, objects_list[i])
        exclusive_values, objects_list1, objects_list2 = get_exclusive_values()
        display_exclusive_values(exclusive_values, objects_list1, 1)
        display_exclusive_values(exclusive_values, objects_list2, 2)
        logging.info("\n")

# TODO:
# mock tests (without real db connection; pass some mock data) - investigate the log..