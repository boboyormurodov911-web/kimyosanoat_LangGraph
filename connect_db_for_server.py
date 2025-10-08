import psycopg2
from sshtunnel import SSHTunnelForwarder

# --- SSH va DB konfiguratsiyasi ---
SSH_HOST = "198.163.207.58"
SSH_USER = "kimyosanoatdb-user"
SSH_PRIVATE_KEY = "/home/tensor/Desktop/id_rsa"  

DB_HOST = "192.168.1.24"
DB_PORT = 5432
DB_NAME = "kimyosanoatdb"
DB_USER = "read-user"
DB_PASS = "read-user"


def run_query(query: str):
    """
    SSH tunnel orqali PostgreSQL bazasiga ulanib, query bajaradi.
    Kirishda: query (string)
    Chiqishda: natija (list yoki tuple)
    """
    try:
        with SSHTunnelForwarder(
            (SSH_HOST, 22),
            ssh_username=SSH_USER,
            ssh_pkey=SSH_PRIVATE_KEY,
            remote_bind_address=(DB_HOST, DB_PORT),
        ) as tunnel:
            print("✅ SSH tunnel o'rnatildi")

            conn = psycopg2.connect(
                dbname=DB_NAME,
                user=DB_USER,
                password=DB_PASS,
                host="127.0.0.1",
                port=tunnel.local_bind_port,
            )
            print("✅ DB ga ulanish muvaffaqiyatli amalga oshirildi.")

            with conn.cursor() as cur:
                cur.execute(query)
                result = cur.fetchall()

            conn.close()
            print("🔒 DB ulanishi yopildi.")
            return result

    except Exception as e:
        print(f"❌ Xatolik yuz berdi: {e}")
        return None