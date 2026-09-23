
import psycopg2
import pandas as pd
from config import Config  # Імпортуємо наш клас з конфігом

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


if __name__ == "__main__":
    test_connection()

