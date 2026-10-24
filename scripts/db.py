
import psycopg2
import pandas as pd
import re
from config import Config  # import config file

_QUERY_PATH ='../sql/metrics.sql'
_CREATE_VIEW_TEXT = 'CREATE OR REPLACE VIEW'

def get_connection():
    return psycopg2.connect(
        host=Config.DB_HOST,
        port=Config.DB_PORT,
        database=Config.DB_NAME,
        user=Config.DB_USER,
        password=Config.DB_PASS
    )

def fetch_data_as_df(query: str, params: tuple = None) -> pd.DataFrame:
    """Run SQL query and return Pandas dataframe"""
    conn = get_connection()
    try:
        df = pd.read_sql_query(query, conn, params=params)
        return df
    finally:
        conn.close()

def test_connection():
    """Verifies that PostgreSQL is reachable and credentials are valid."""
    try:
        conn = get_connection()
        # Create a cursor to execute a lightweight test query
        with conn.cursor() as cursor:
            cursor.execute("SELECT version();")
            db_version = cursor.fetchone()
            print("Successfully connected to PostgreSQL!")
            print(f"Database Version: {db_version[0]}")

        # Always close the connection
        conn.close()
        return True
    except Exception as e:
        print(f"Failed to connect to PostgreSQL: {e}")
        return False

def get_sql_query(filename, **kwargs):

    '''It returns a SQL query string from filename'''

    with open(filename, 'r') as file:
        sql_query = file.read().format(**kwargs)

    return sql_query

# def get_data_from_db(customer_id):
#     sql_file = 'sql_queries/get_data.sql'
#     sql_query = get_sql_query(sql_file, customer_id=customer_id)



def get_list_of_target_views(str_query):

    ''' It parses SQL query and return list of target view names '''

    view_name_list = []
    str_query = str(get_sql_query(_QUERY_PATH))

    while True:
        try:
            pattern = rf"{re.escape(_CREATE_VIEW_TEXT)}[\s](\w+)"
            match = re.search(pattern, str_query)
            view_name = match.group(1)

            print(f"The target view name: '{view_name}'")
            view_name_list.append(view_name)
            drop_part = str_query.find(view_name)
            str_query = str_query[drop_part::]

        except AttributeError:
            break  # End of func

    return view_name_list

if __name__ == "__main__":
    test_connection()
    str_views_query = str(get_sql_query(_QUERY_PATH))
    print(get_list_of_target_views(str_views_query))
