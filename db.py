import psycopg2
import psycopg2.extras
import os

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "postgres")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "1")

def get_connection():
    return psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        cursor_factory=psycopg2.extras.RealDictCursor
    )


def save_chat_to_db(session_id: str, question: str, answer: str):
    conn = get_connection()
    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO chat_history (session_id, user_question, assistant_answer)
            VALUES (%s, %s, %s)
        """, (session_id, question, answer))
    conn.commit()
    conn.close()

def get_last_chats(session_id: str, limit: int = 10):
    conn = get_connection()
    with conn.cursor() as cur:
        cur.execute("""
            SELECT user_question, assistant_answer
            FROM chat_history
            WHERE session_id = %s
            ORDER BY created_at DESC
            LIMIT %s
        """, (session_id, limit))
        rows = cur.fetchall()
    conn.close()

    if not rows:
        return ""
    
    # eng eski yozuvlarni avval chiqaramiz
    rows = rows[::-1]
    context = "\n".join(
        [f"User: {row['user_question']}\nAssistant: {row['assistant_answer']}" for row in rows]
    )
    return f"Oldingi suhbatlar:\n{context}\n\n"
