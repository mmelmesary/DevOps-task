import time
import psycopg2
from psycopg2 import OperationalError

DB_NAME = "citus"
DB_USER = "postgres"
DB_PASSWORD = "postgres"
DB_HOST = "localhost"
DB_PORT = 5000

def run_sql_file(cursor, filepath):
    print(f"Executing {filepath} ...")
    with open(filepath, 'r') as f:
        sql_statements = f.read()
        cursor.execute(sql_statements)

def connect_with_retry(dsn, retries=5, delay=3):
    for attempt in range(retries):
        try:
            print(f"Trying to connect (attempt {attempt + 1})...")
            conn = psycopg2.connect(**dsn)
            print("Connected successfully.")
            return conn
        except OperationalError as e:
            print(f"Connection failed: {e}")
            if attempt < retries - 1:
                print(f"Retrying in {delay} seconds...")
                time.sleep(delay)
            else:
                raise
    return None

def main():
    dsn = {
        "dbname": DB_NAME,
        "user": DB_USER,
        "password": DB_PASSWORD,
        "host": DB_HOST,
        "port": DB_PORT
    }

    conn = None
    retries = 3
    delay = 5

    try:
        conn = connect_with_retry(dsn, retries=retries, delay=delay)
        conn.autocommit = True
        cur = conn.cursor()

        run_sql_file(cur, './sql/create_tables.sql')
        run_sql_file(cur, './sql/insert_data.sql')
        run_sql_file(cur, './sql/queries.sql')

        rows = cur.fetchall()
        for row in rows:
            print(row)

        cur.close()

    except Exception as e:
        print(f"Error: {e}")

    finally:
        if conn:
            conn.close()
            print("Connection closed.")

if __name__ == "__main__":
    main()