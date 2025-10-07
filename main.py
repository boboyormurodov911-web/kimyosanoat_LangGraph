import re
import os
import google.generativeai as genai
from fastapi import FastAPI
from pydantic import BaseModel
from langgraph.graph import StateGraph, END
import psycopg2
from psycopg2.extras import RealDictCursor
from connect_db import run_query   # SQL query bajarish uchun sizning mavjud funksiya


# =====================
# 🔹 DB ulanish
# =====================
conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="1",
    host="127.0.0.1",
    port=5432,
)


# =====================
# 🔹 Yordamchi funksiya
# =====================
def extract_sql(text: str) -> str:
    """LLM javobidan faqat SQL queryni olish"""
    match = re.search(r"```sql\s*(.*?)\s*```", text, re.DOTALL | re.IGNORECASE)
    if match:
        return match.group(1).strip()
    return text.strip()


# =====================
# 🔑 LLM sozlamalar
# =====================


API_KEY = os.getenv("GEMINI_API_KEY", "AIzaSyC3bKIoW-GlEBDgLJ6FwOxWrfBM4cm6PnY")
genai.configure(api_key=API_KEY)
gemini = genai.GenerativeModel("models/gemini-2.5-flash")


# =====================
# 📂 Metadata fayldan o‘qish
# =====================
DDL_FILE = os.getenv("DDL_FILE", "ddl.txt")
if not os.path.exists(DDL_FILE):
    raise FileNotFoundError(f"Schema fayl topilmadi: {DDL_FILE}")

with open(DDL_FILE, "r", encoding="utf-8") as f:
    METADATA_SCHEMA = f.read()


# =====================
# 🔹 Chat Memory (DB + session_id)
# =====================
def save_chat_to_db(session_id: str, question: str, answer: str):
    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO chat_history (session_id, user_question, assistant_answer)
            VALUES (%s, %s, %s)
        """, (session_id, question, answer))
        conn.commit()


def get_last_chats(session_id: str, limit: int = 10):
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(
            "SELECT user_question, assistant_answer FROM chat_history WHERE session_id=%s ORDER BY created_at DESC LIMIT %s",
            (session_id, limit)
        )
        rows = cur.fetchall()
    return [f"User: {r['user_question']}\nAssistant: {r['assistant_answer']}" for r in rows]


# =====================
# 🔹 State Graph
# =====================
class State(dict):
    question: str
    sql_query: str
    sql_result: list
    final_answer: str
    session_id: str
    is_db: bool


# 0️⃣ Savol DB ga aloqadorligini tekshirish
def is_db_question(state: State):
    prompt = f"""
    Savol: {state['question']}

    Quyidagi sxema mavjud:
    {METADATA_SCHEMA}

    Agar savol ma'lumotlar bazasi sxemasiga, jadvallarga yoki SQL so'rovlarga aloqador bo'lsa 
    faqat "YES" deb javob ber.
    Agar oddiy suhbat, umumiy savol yoki bazaga bog'liq bo'lmasa faqat "NO" deb javob ber.
    """
    response = gemini.generate_content(prompt).text.strip().upper()
    if "YES" in response:
        return {"is_db": True}
    return {"is_db": False}


# 1️⃣ Savoldan SQL query tuzish
def generate_sql(state: State):
    chat_context = get_last_chats(state["session_id"])
    prompt = f"""
    {chat_context}

    Foydalanuvchi savoli: {state['question']}
    Ma’lumotlar bazasi sxemasi (DDL/schema): {METADATA_SCHEMA}

    Faqatgina SQL so‘rovini yozing (PostgreSQL sintaksisida).
    """
    sql_query = gemini.generate_content(prompt).text.strip()
    return {"sql_query": sql_query}


# 2️⃣ SQL bajarish
def execute_sql(state: State):
    sql_query = extract_sql(state["sql_query"])
    print("▶️ SQL:", sql_query)
    res = run_query(sql_query)
    print("✅ DB result:", res)
    return {"sql_result": res}


# 3️⃣ Yakuniy javob tayyorlash (DB asosida)
def generate_answer(state: State):
    chat_context = get_last_chats(state["session_id"])
    prompt = f"""
    {chat_context}

    Foydalanuvchi savoli: {state['question']}
    SQL natijasi: {state['sql_result']}

    Aniq va foydalanuvchiga qulay qilib javob yozing.
    """
    answer = gemini.generate_content(prompt).text.strip()
    save_chat_to_db(state["session_id"], state["question"], answer)
    return {"final_answer": answer}


# 4️⃣ Oddiy suhbat (DBga aloqasi yo‘q)
def chit_chat_answer(state: State):
    chat_context = get_last_chats(state["session_id"])
    prompt = f"""
    {chat_context}

    Foydalanuvchi: {state['question']}

    Bu savol bazaga bog'liq emas. Shunchaki suhbatlashish ohangida, sodda va tushunarli javob yoz.
    """
    answer = gemini.generate_content(prompt).text.strip()
    save_chat_to_db(state["session_id"], state["question"], answer)
    return {"final_answer": answer}


# =====================
# 🔹 Graph tuzish
# =====================
workflow = StateGraph(State)
workflow.add_node("is_db_question", is_db_question)
workflow.add_node("generate_sql", generate_sql)
workflow.add_node("execute_sql", execute_sql)
workflow.add_node("generate_answer", generate_answer)
workflow.add_node("chit_chat_answer", chit_chat_answer)

workflow.set_entry_point("is_db_question")

workflow.add_conditional_edges(
    "is_db_question",
    lambda state: "db" if state["is_db"] else "chat",
    {
        "db": "generate_sql",
        "chat": "chit_chat_answer",
    },
)

workflow.add_edge("generate_sql", "execute_sql")
workflow.add_edge("execute_sql", "generate_answer")
workflow.add_edge("generate_answer", END)
workflow.add_edge("chit_chat_answer", END)

graph = workflow.compile()


# =====================
# 🔹 FastAPI qismi
# =====================
app = FastAPI(title="LLM-SQL API", version="1.4 (Session Memory + ChitChat)")


class QueryRequest(BaseModel):
    session_id: str
    question: str


@app.post("/ask")
def ask_llm(req: QueryRequest):
    api_keys=["AIzaSyDowP73pz1YAtKGjjvq1YeUeq44cuFYh18","AIzaSyCqKkZoSPoYeAQtqFftOr4JbzQArMvJgv4","AIzaSyBFhrn9GqS5l8HNPmhQ9iP8V1OeEeVoS7s","AIzaSyD1qtya5p7LXhhMJdWqUPYwgou04z_9ObI","AIzaSyCNp3PfUWLtXhHSeuyIN5IUf7TxIP9ByCE","AIzaSyCP8Nv35pANT3mVfAz4QPCuQhDq9ik34uA"]

    with conn.cursor() as cur:
        cur.execute("SELECT number_of_answer FROM javoblar WHERE id = 1")
        number=cur.fetchone()[0]

    print(number)

    api_key=api_keys[number%6]

    print(api_key)

    genai.configure(api_key=api_key)
    global gemini
    gemini = genai.GenerativeModel("models/gemini-2.5-flash")


    result = graph.invoke({"session_id": req.session_id, "question": req.question})

    with conn.cursor() as cur:
        # ✅ TO'G'RI SINTAKSIS: column so'zini olib tashlang
        cur.execute("UPDATE javoblar SET number_of_answer = number_of_answer + 1 WHERE id = 1;")
        conn.commit()


    return {
        "question": req.question,
        "is_db": result.get("is_db", False),
        "sql_query": extract_sql(result["sql_query"]) if result.get("sql_query") else None,
        "final_answer": result["final_answer"],
    }
