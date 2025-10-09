import psycopg2

conn = psycopg2.connect(
    dbname="kimyosanoataidb",
    user="kimyosanoatai-user",
    password="39uWfFEy4qt9orC0MuuJ",
    host="192.168.1.24",
    port=5432,
)

def create_tables():
    cur = conn.cursor()

    # --- javoblar ---
    cur.execute("""
        CREATE TABLE IF NOT EXISTS javoblar (
            id SERIAL PRIMARY KEY,
            number_of_answer INT
        );
    """)

    # 🔹 faqat id=1 mavjud bo‘lmasa qo‘shadi
    cur.execute("""
        INSERT INTO javoblar (id, number_of_answer)
        VALUES (1, 0)
        ON CONFLICT (id) DO NOTHING;
    """)

    # --- chat_history ---
    cur.execute("""
        CREATE TABLE IF NOT EXISTS chat_history1 (
            id SERIAL PRIMARY KEY,
            session_id VARCHAR(255) NOT NULL,
            user_question TEXT NOT NULL,
            assistant_answer TEXT,
            created_at TIMESTAMP DEFAULT NOW()
        );
    """)

    conn.commit()
    cur.close()
    conn.close()
    print("✅ Barcha jadvallar yaratildi!")

if __name__ == "__main__":
    create_tables()
