import psycopg2



conn = psycopg2.connect(
    dbname="aidb2",
    user="ai-user",
    password="63D9WFhW4S4GQOXaPkyj",
    host="192.168.1.7",
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
    assistant_answer TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);""")


    conn.commit()
    cur.close()
    conn.close()
    print("✅ Barcha jadvallar yaratildi!")


if __name__ == "__main__":
    create_tables()
