import psycopg2

try:
    conn = psycopg2.connect(
        dbname="aidb2",
        user="ai-user",
        password="63D9WFhW4S4GQOXaPkyj",
        host="192.168.1.7",
        port=5432,
    )

    with conn.cursor() as cur:
        # Jadval bo'lmasa yaratish
        cur.execute("""
            CREATE TABLE IF NOT EXISTS javoblar (
                id SERIAL PRIMARY KEY,
                number_of_answer INT
            );
        """)
        # Bitta 0 qiymat qo'shish
        cur.execute("""
            INSERT INTO javoblar (number_of_answer) VALUES (0);
        """)
        conn.commit()

    conn.close()
    print("🔒 DB ulanishi yopildi.")

except Exception as e:
    print(f"❌ Xatolik yuz berdi: {e}")