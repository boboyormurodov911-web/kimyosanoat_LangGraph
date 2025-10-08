import psycopg2
from sshtunnel import SSHTunnelForwarder

DB_HOST = "192.168.1.24"
DB_PORT = 5432
DB_NAME = "kimyosanoatdb"
DB_USER = "read-user"
DB_PASS = "read-user"

conn = psycopg2.connect(
                dbname=DB_NAME,
                user=DB_USER,
                password=DB_PASS,
                host=DB_HOST,
                port=DB_PORT
            )

def run_query(query: str):

    try:
        with conn.cursor() as cur:
                cur.execute(query)
                result = cur.fetchall()

        conn.close()
        print("🔒 DB ulanishi yopildi.")
        return result

    except Exception as e:
        print(f"❌ Xatolik yuz berdi: {e}")
        return None
