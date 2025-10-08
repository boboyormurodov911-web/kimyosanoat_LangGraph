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
    
    cur.execute("""
            INSERT INTO javoblar (number_of_answer) VALUES (0);
        """)


    #--- chat history ---
    cur.execute("""
    CREATE TABLE IF NOT EXISTS chat_history (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) NOT NULL,
    user_question TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);""")


    conn.commit()
    cur.close()
    conn.close()
    print("✅ Barcha jadvallar yaratildi!")


if __name__ == "__main__":
    create_tables()
