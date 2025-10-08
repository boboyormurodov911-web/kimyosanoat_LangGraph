import psycopg2
from psycopg2 import sql

DB_HOST = "192.168.1.24"
DB_PORT = 5432
DB_NAME = "kimyosanoatdb"
DB_USER = "read-user"
DB_PASS = "read-user"


def run_query(query: str):
    """SQL so‘rovni bajaradi va natijani qaytaradi."""
    try:
        # Har safar yangi ulanish ochamiz
        with psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            host=DB_HOST,
            port=DB_PORT
        ) as conn:

            with conn.cursor() as cur:
                cur.execute(query)

                # Agar SELECT bo‘lsa — natijani qaytaramiz
                if query.strip().lower().startswith("select"):
                    result = cur.fetchall()
                else:
                    conn.commit()
                    result = None

        print("🔒 DB ulanishi muvaffaqiyatli yopildi.")
        return result

    except Exception as e:
        print(f"❌ Xatolik yuz berdi: {e}")
        return None
