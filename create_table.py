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



    conn.commit()
    cur.close()
    conn.close()
    print("✅ Barcha jadvallar yaratildi!")


if __name__ == "__main__":
    create_tables()
