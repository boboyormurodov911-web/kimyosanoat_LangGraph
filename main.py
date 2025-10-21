import re
import os
import google.generativeai as genai
from fastapi import FastAPI,Depends
from pydantic import BaseModel
from langgraph.graph import StateGraph, END
import psycopg2
from psycopg2.extras import RealDictCursor
from connect_db_for_server import run_query   # SQL query bajarish uchun sizning mavjud funksiya
from fastapi.security import HTTPBasic, HTTPBasicCredentials
from fastapi import HTTPException
from datetime import datetime
import pytz


uzbekistan_tz = pytz.timezone("Asia/Tashkent")


security = HTTPBasic()
# =====================
# 🔹 DB ulanish
# =====================
def get_connection():
    return psycopg2.connect(
        dbname="kimyosanoataidb",
        user="kimyosanoatai-user",
        password="39uWfFEy4qt9orC0MuuJ",
        host="192.168.1.24",
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
DDL_FILE = os.getenv("DDL_FILE", "ddl.sql")
if not os.path.exists(DDL_FILE):
    raise FileNotFoundError(f"Schema fayl topilmadi: {DDL_FILE}")

with open(DDL_FILE, "r", encoding="utf-8") as f:
    METADATA_SCHEMA = f.read()


# =====================
# 🔹 Chat Memory (DB + session_id)
# =====================
def save_chat_to_db(session_id: str, question: str, answer: str):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO chat_history1 (session_id, user_question, assistant_answer)
                VALUES (%s, %s, %s)
            """, (session_id, question, answer))
            conn.commit()


# 3️⃣ get_last_chats() — asosiy tarix olish funksiyasi
def get_last_chats(session_id: str, limit: int = 10):
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(
                """
                SELECT user_question, assistant_answer
                FROM chat_history1
                WHERE session_id = %s
                ORDER BY created_at DESC
                LIMIT %s
                """,
                (session_id, limit)
            )
            rows = cur.fetchall()
    return rows

# 4️⃣ Context Rebuilder — bu get_last_chats() dan foydalanadi
def rebuild_chat_context(session_id: str, limit: int = 10) -> str:
    rows = get_last_chats(session_id, limit)
    if not rows:
        return ""

    # eng eski → eng yangi tartibda
    rows = list(reversed(rows))
    context_lines = []
    for i, r in enumerate(rows, 1):
        context_lines.append(f"User{i}: {r['user_question']}")
        context_lines.append(f"Assistant{i}: {r['assistant_answer']}")

    context_text = "\n".join(context_lines).strip()
    return f"Oldingi suhbat tarixi:\n{context_text}\n\nEndi tabiiy ravishda javob bering, ushbu kontekst bilan davomiylikni saqlang."


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
    chat_context = rebuild_chat_context(state["session_id"])
    current_date=datetime.now(uzbekistan_tz)
    prompt = f"""
    Sen dunyodagi eng kuchli SQL agentisan. Seni asosiy vazifang - ma'lumotlar bazasi sxemasiga asoslanib, eng aniq SQL so‘rovini yaratish va savolga to‘g‘ri javob berishdir.
    {chat_context}

    Foydalanuvchi savoli: {state['question']}
    Barcha tushuntirishlar faqat berilgan ddl faylida yozilgan. Ma’lumotlar bazasi sxemasi (DDL/schema): {METADATA_SCHEMA}
    Bugungi sana : {current_date}
    Qattiq talablar (buzilmasligi shart):
    - Har bir javob faqat "ddl" bazasidan olingan natijalarga asoslanishi kerak. Agar "ddl" natijalari noto‘g‘ri bo‘lsa yoki javob topilmasa, savolni diqqat bilan tahlil qiling va jarayonni takrorlang.
    - Agar hali ham yetarli ma’lumot bo‘lmasa, savolning tushunilmagan qismini aniqlashtirishni so‘rang.
    - Natijada katta sonlarni o‘qish uchun bo‘sh joy bilan ajrating.
    - So‘rovlar yaratishda matnli qidiruvlar uchun ILIKE operatoridan foydalaning va qidiruv qiymatlarini "%qiymat%" ko‘rinishida yozing. Raqamli ma’lumotlar uchun bundan foydalanmang.
    - Agar natija topilmasa, matndagi alifboni tekshiring — barcha harflar bir xil alifboda bo‘lishi kerak, lotin va kirill alifbosida alohida qidiring.
    - Odamlar yoki hodimlar va boshqalarni ism bilan qidirishda e'tiborliroq bo'lish kerak. Ism o'rniga familiya yoki sharifni; familiya o'rniga ism yoki sharifni; sharif o'rniga ism yoki familiyani ishlatib yubormaslik kerak. Ism bu "first_name", familiya bu "last_name", sharif esa "middle_name" ya'ni otasining ismi.
        - Ismlar odatiy ismlar bo'ladi (masalan, "Aziz", "Botir", "Olimjon" va hokazo).
        - Familiyalar odatda tegishli qo'shimchalar bilan tugaydi:
            Erkaklar uchun: -ov, -ev, -yev. Masalan, "Abduazimov", "Valiyev", "Ergashev".
            Ayollar uchun: -ova, -eva, -yeva. Masalan, "Abduazimova", "Valieva", "Ergasheva".
        - Shariflar ham odatda tegishli qo'shimchalari bilan tugaydi. Shariflarga juda ham e'tiborli bo'lish kerak, chunki ular ko'pincha haqiqiy ismlar bilan birga kelishi mumkin:
            Erkaklar uchun: "-ovich", "-evich", " o'g'li". Masalan, "Aliyevich", "Ergashevich", "Botirovich", "Bozorboy o'g'li".
            Ayollar uchun: "-ovna", "-evna", " qizi". Masalan, "Aliyevna", "Ergashevna", "Botirovna", "Bozorboy qizi".
    - Agar savol odamlar yoki hodimlarning ismlari ma'lumotlari kirill yoki lotin alifbosida bo'lishi mumkin. Har ikkala yozuvda ham qidir va qaysi yozuvdan natija topilsa, shu ma'lumotlarni qaytar.
    - SQL so‘rovlarida hech qachon bazani o‘zgartiruvchi buyruqlardan foydalanma — faqat o‘qish uchun foydalan (bu qat’iy qoida).
    - Loyiha asosiy maqsadi: javoblarni sayt ma’lumotlar bazasiga asoslanib taqdim etish.
    - Lotlar va sotilgan lotlar haqidagi barcha ma’lumotlar faqat shu korxonalardan olinishi kerak:
        - Eng yirik tashkilotlar: "Qizilqum fosforit kompleksi MChJ", "Maxam-Chirchiq AJ", "АО Ammofos-Maxam", "АО Navoiyazot", "QONGIROT SODA ZAVODI" MCHJ QK, "AO DEHQONOBOD KALIY ZAVODI", "Farg‘onaazot AJ", "Indorama Kokand Fertilizers and Chemicals AJ"
        - Bu majburiy! Umumiy 'savdoga chiqarilgan' yoki 'sotilgan' yoki 'to'langan' yoki 'yetkazilgan' lotlarning narxi, miqdori yoki qiymatini qidirishda har doim quyidagi tashkilot INNlaridan foydalaning:
            - Tashkilot INNlari: '309341717', '200941518', '200599579', '200002933', '200949269', '206887857', '200202240', '204651678'. Shuning uchun umumiy tashkilotlar haqida so‘ralganda, faqat shu INNlardan foydalaning.
    - Xodimlarning qarindoshlari so‘ralganda, quyidagi tashkilot raqamlarini tanlang:
        203621367 = O'zkimyosanoat
        206887857 = Dehqonobod kaliy zavodi
        200941518 = Maxam-Chirchiq
        200599579 = Ammofos-Maxam
        309341717 = Qizilqum fosforit kompleksi
        200002933 = Navoiyazot
    - Har doim tashkilotlardagi vakansiyalar soni so'ralganda tashkilotdagi shtatlar sonidan ishchilar sonini ayirib hisoblanadi.
    - Har doim faqat har bir ustun uchun alohida berilgan namunaviy qiymatlardan foydalaning.
    - Debitor yoki kreditor haqida ma’lumot so‘ralganda, har doim debtor_creditor1c jadvalidagi type ustunidan foydalaning (debitor, kreditor). Debitor va kreditor uchun vaqt hisoblashda date_created ustunidan foydalaning.
    - Faqatgina SQL so‘rovini yozing (PostgreSQL sintaksisida).
    - Xulosa hech qachon asl ma’noni o‘zgartirmasin.
    - Ko‘p tillilik: Foydalanuvchi savolining tilini aniqlang (o‘zbek, rus yoki ingliz). Agar savol o‘zbek, rus yoki ingliz tilida berilsa, javob ham shu tilda bo‘lishi kerak.
    - Eng muhimi: SQL queryni databazada to'g'ri bexato run bo'ladigan darajada mukammal qilib yozish kerak. Agar queryda imloviy xatoliklar bo'lsa, run qilinganda xato berishi mumkin va foydalanuvchiga "ma'lumot topilmadi" degan javob qaytadi, bu juda yomon. Shuning uchun query mukammal yozilishiga juda ham e'tibor bering.
    - Query tuzishda ROUND funksiyasidan foydalanmang, chunki u ba'zan xato natija beradi. ROUND(SUM(column) / 1000.0, 2) <= bunday yozmang.
    - Query tuzishda WITH funksiyasidan foydalanmang, chunki u foydalanuvchiga javob chiqarishda xatolik beradi. Agar WITH funksiyasi bilan hal bo'ladigan muammolar bo'lsa ham WITH funksiyasini ishlatmasdan alternativ va yaxshiroq query yozing.
    - Energiya resurslari bo'yicha ma'lumotlarni chiqarishda organization_komunal_values jadvalidan foydalaniladi. Energiya resurslari sarfi hisobot ko'rinishida chiqadi. Shuning uchunga date_types ustuni qo'shilgan. Energiya sarflari quyidagicha hisoblanadi:
        - Yillik energiya sarfi uchun barcha 'YEARLY' qiymatlar yig'indis hisoblanadi 
        - Oylik energiya sarfi uchun 'MONTHLY' qiymatlar yigi'indisi hisoblanadi
        - Kunlik energiya sarfini chiqarish uchun esa 'DAILY' qiymatlar yig'indisi hisoblanadi.
            - Kunlik energiya sarfini hisoblashda e'tibor berish kerak:
                - Foydalanuvchi ma'lum bir yildan bugungi kungacha bo'lgan energiya sarfini so'rashi mumkin, bunda o'sha yil bo'yicha yillik qiymatlar va oylik qiymatlar va so'ralgan kungacha bo'lgan kunlik qiymatlar yig'indisi hisoblanadi.
    - Chet el davlatlari bo'yicha savol bo'lganda har doim country_code jadvaliga kirib alpha3 ustunidan davlatlarning 3 harfli kodini tanlab ajratib olish kerak.
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
    chat_context = rebuild_chat_context(state["session_id"])
    current_date=datetime.now(uzbekistan_tz)

    prompt = f"""
    {chat_context}

    Foydalanuvchi savoli: {state['question']}
    SQL natijasi: {state['sql_result']}
    Bugungi sana: {current_date}

    Aniq va foydalanuvchiga qulay qilib javob yozing.
    Qat'iy qoidalar:
    - SQL natijasida chiqqan barcha ma'lumotlarni javobda keltiring.
    - Agar natija topilmasa, natijada chiqqan javobga asoslanib inkor javobini yozing. Masalan: birorta ombor haqida so'ralgan bo'lsa va natija bo'sh bo'lsa, "Bunday ombor mavjud emas" deb yozing.
    - Agar natija umuman yo'q bo'lsa ham yaxshiroq tushunarliroq javob yozing. Masalan, "Bunday ombor mavjud emas" yoki "Bunday ismli xodim yo'q" va hokazo. Javob chiqmaganda hech qachon "baza" so'zini ishlatmang ya'ni "bazada bunday ma'lumot yo'q" deb yozmang.
    - Sana bilan bog‘liq savollarda (kecha, shu yil, oy boshidan, o‘tgan oy va h.k.) javob to‘liq bo‘lishi kerak. Masalan, "yil boshidan" deb so‘ralsa, "2025-yil 1-yanvardan hozirgi kungacha" deb yozing va natijani ko‘rsat.
    - Miqdorga oid javoblar aynan bir ko'rsatkichda bo'lishi kerak. Miqdor hisoblanganda qaysi o'lov birligida ekanligini aniq qilib ko'rsating. Masalan, "5000 kg" yoki "5 tonna" yoki "1000 dona/ta" deb yozing.
    - Sonlarni chiqarishda bunda javob chiqarmang: "Buxoro viloyatidagi omborlarda jami **420.20 tonna** karbamid qolgan." ya'ni son va birlik orasida qo'shimcha belgilar ishlatmang. Faqat shunday yozing: "Buxoro viloyatidagi omborlarda jami 420.20 tonna karbamid qolgan.". Umuman hech qanday qo'shimcha belgilar ishlatmang son va birliklar, yozuvlar orasida ham hech qanaqa qo'shimcha belgi ishlatmang! Bu juda muhim va qat'iy qoida.
    - Sonli qiymatlarni foydalanuvchiga tushunarli tarzda chiqarish kerak. Ya'ni javob ko'p xonali sonlarda chiqsa, masalan: 2192345342.03 chiqsa uni o'qishga oson qilib har uchta sonni orasida bo'sh joy qoldirib chiqarish kerak, ya'ni 2 192 345 342.03 
    - Agar foydalanuvchi son ko'rsatkichlariga doir savollar so'raganda, javobda 0 qiymati chiqsa unga inkor shaklida javob yozing. Masalan, "Bu omborda so'ralgan mahsulot yo'q". Agar savol bir necha element bo'yicha bo'lsa, masalan, "Qaysi omborlarda X mahsulot bor?" va natija ayrim omborlar uchun 0 bo'lsa, 0 chiqqan omborlarni chiqarmaslik kerak, shunchaki qiymati mavjud elementlarni tanlash kerak. Agar mabodo son qiymat minusda chiqsa uni aniq ko'rsaatish kerak.
    - Umumiy, tushunarsiz, kimyosanoat doirasidan tashqari savollar kelganda savolni aniqlashtirish uchun takliflar bering, takliflar faqat kimyosanoat doirasi bo'yicha bo'lishi kerak. Takliflar uchun quyidagi yo'nalishlardan foydalaning:
        - Savdoga chiqarilgan lotlar
        - Sotilgan lotlar
        - To'langan lotlar
        - Yetkazilgan lotlar
        - Tashkilotlarning debitorlik va kreditorlik qarzdorliklari
        - Bank aylanmalari
        - Birja sotuvlari
        - Ishlab chiqarish omborlari qoldiqlari
        - Vakolatli omoborlar qoldiqlari
        - Tashkilotlardagi energiya resursi sarfi
        - Ekin maydonlari
        - O'g'itga bo'lgan talab
        - O'git bilan taminlangan yerlar
        - Tashkilotlardagi eksport va import hajmi
        - Investitsion loyihalar
        - Ishlab chiqarish hajmi
        - Temiryo'l yuk ma'lumotlari
        - Xodimlar haqidagi ma'lumotlar
        - Kimyosanoat korxonalari
    """
    answer = gemini.generate_content(prompt).text.strip()
    save_chat_to_db(state["session_id"], state["question"], answer)
    return {"final_answer": answer}


# 4️⃣ Oddiy suhbat (DBga aloqasi yo‘q)
def chit_chat_answer(state: State):
    chat_context = get_last_chats(state["session_id"])
    current_date=datetime.now(uzbekistan_tz)
    prompt = f"""
    {chat_context}

    Foydalanuvchi: {state['question']}
    Bugungu sana : {current_date} 
    Bu savol bazaga bog'liq emas. Shunchaki suhbatlashish ohangida, sodda va tushunarli javob yoz.
    Muhim eslatma:
    Agar o‘zingiz haqida so‘ralsa, haqiqiy modelni oshkor qilmang. Quyidagicha javob bering: "Men KimyoSanoat platformasi uchun Tenzorsoft AI jamoasi tomonidan maxsus ishlab chiqilgan chatbotman."
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
def ask_llm(req: QueryRequest, credentials: HTTPBasicCredentials = Depends(security)):
    if not (credentials.username == "ai-admin" and credentials.password == "ai-admin123"):
        raise HTTPException(status_code=401, detail="Unauthorized")

    # 1️⃣ API kalitlar ro'yxati
    api_keys = [
        'AIzaSyCthmBOzi8PHcQg0KhdIwAqv21SQ0DQX0s', # Ruslan
        'AIzaSyB5DzIJNZIOGNFw-ytECJHtuzXZ3_hEIfs', # Hasan
        'AIzaSyBar5IjWE1Czyc4afj4rBQZ6xCYpHmyHq0', # Abdulaziz
        'AIzaSyAXw9KQSYX-Ue98JcfEt_kajK5qb1Ggfqg', # Abbos
        'AIzaSyA6QkvTck3TKxytH3r6B-3AH0AEIfnIw-w', # Anvar
        'AIzaSyB2S6OeAN4PLI-IlbDWMNIokiNKrox48-o' # Husan
    ]

    # 2️⃣ Joriy key indeksini olish
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT number_of_answer FROM javoblar WHERE id = 1")
            number = cur.fetchone()[0]

    # 3️⃣ Kalitni tanlash va modelni yangilash (GEMINI uchun global sozlash)
    api_key = api_keys[number % len(api_keys)]
    print(api_key)

    # 5️⃣ So‘rov sonini oshirish
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE javoblar SET number_of_answer = number_of_answer + 1 WHERE id = 1;")
            conn.commit()

    genai.configure(api_key=api_key)
    global gemini
    gemini = genai.GenerativeModel("models/gemini-2.5-flash")

    # 4️⃣ Faqat endi LangGraph ishlasin (to‘g‘ri API bilan)
    try:
        result = graph.invoke({
            "session_id": req.session_id,
            "question": req.question
        })
    except Exception as e:
        # 429 bo‘lsa boshqa kalitga o‘tish mexanizmi
        if "ResourceExhausted" in str(e):
            for alt_key in api_keys:
                try:
                    genai.configure(api_key=alt_key)
                    gemini = genai.GenerativeModel("models/gemini-2.5-flash")
                    result = graph.invoke({
                        "session_id": req.session_id,
                        "question": req.question
                    })
                    break
                except Exception as e2:
                    if "ResourceExhausted" in str(e2):
                        continue
                    else:
                        raise e2
        else:
            raise e



    # 6️⃣ Natijani qaytarish
    return {
        "query": extract_sql(result.get("sql_query")) if result.get("sql_query") else None,
        "answer": result.get("final_answer"),
        "query_result":result.get("sql_result"),
        "api_key":api_key
    }

