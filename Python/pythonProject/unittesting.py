import unittest
from unittest.mock import patch
import psycopg2
from db_schema_comparison import (
    get_schema_obj_info,
    execute_cursor,
    schema_db1_info_object,
    schema_db2_info_object,
    get_unique_values,
    display_unique_values,
)
import io


class TestScriptFunctionality(unittest.TestCase):
    def test_get_schema_obj_info(self):
        # Test the get_schema_obj_info function
        # Provide mock database parameters and ensure it returns the expected results

        mock_params = {
            'host': 'localhost',
            'port': '5432',
            'database': 'dvdrental',
            'user': 'postgres',
            'password': 'p0$tgre$',
        }

        schema_db_info_object = {}
        object_type = 'tables'  # Choose any object type for testing

        result = get_schema_obj_info(mock_params, schema_db_info_object, object_type)

        # Check if the result is a tuple
        self.assertIsInstance(result, tuple)

        # Check if the first element of the tuple is an integer (count)
        self.assertIsInstance(result[0], int)

        # Check if the second element of the tuple is a string (object_type)
        self.assertIsInstance(result[1], str)

    def test_execute_cursor(self):
        # Test the execute_cursor function
        # Provide a mock cursor and ensure it executes the query correctly

        mock_params = {
            'host': 'localhost',
            'port': '5432',
            'database': 'dvdrental',
            'user': 'postgres',
            'password': 'p0$tgre$',
        }

        mock_cursor = psycopg2.connect(**mock_params).cursor()  # Use an actual connection string for the test

        schema_db_num = {}
        object_type = 'tables'  # Choose any object type for testing

        result = execute_cursor(mock_cursor, schema_db_num, object_type)

        # Check if the result is a tuple
        self.assertIsInstance(result, tuple)

        # Check if the first element of the tuple is an integer (count)
        self.assertIsInstance(result[0], int)

        # Check if the second element of the tuple is a string (object_type)
        self.assertIsInstance(result[1], str)

    def test_get_unique_values(self):
        # Test the get_unique_values function
        # Provide mock schema information and ensure it returns the expected results

        mock_schema_db1_info_object = {'schema_objects': [('object1',), ('object2',)]}
        mock_schema_db2_info_object = {'schema_objects': [('object2',), ('object3',)]}

        schema_db1_info_object['schema_objects'] = mock_schema_db1_info_object['schema_objects']
        schema_db2_info_object['schema_objects'] = mock_schema_db2_info_object['schema_objects']

        result = get_unique_values()

        # Check if the result is a tuple
        self.assertIsInstance(result, tuple)

        # Check if the first element of the tuple is a set
        self.assertIsInstance(result[0], set)

        # Check if the second and third elements of the tuple are lists
        self.assertIsInstance(result[1], list)
        self.assertIsInstance(result[2], list)

    def test_display_unique_values(self):
        # Test the display_unique_values function
        # Provide mock unique values and ensure it prints the expected output

        mock_unique_values = {'object1', 'object3'}
        mock_objects_list = ['tables', 'routines', 'objects']
        mock_db_num = 1

        # Redirect stdout to capture print statements
        with unittest.mock.patch('sys.stdout', new_callable=io.StringIO) as mock_stdout:
            display_unique_values(mock_unique_values, mock_objects_list, mock_db_num)

            # Get the printed output
            printed_output = mock_stdout.getvalue()

        # Check if the printed output contains the expected information
        self.assertIn('DB1', printed_output)
        self.assertIn('OBJECTS', printed_output)
        self.assertIn('object1', printed_output)
        self.assertNotIn('object2', printed_output)  # Ensure that non-unique values are not printed


if __name__ == '__main__':
    unittest.main()
