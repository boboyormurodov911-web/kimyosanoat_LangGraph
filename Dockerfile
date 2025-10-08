# Python bazaviy imij
FROM python:3.12-slim

# Ishchi papka
WORKDIR /app

# requirements.txt faylini ko‘chirib olish
COPY requirements.txt .

# Kerakli kutubxonalarni o‘rnatish
RUN pip install --no-cache-dir -r requirements.txt

# Loyihangizdagi barcha fayllarni ko‘chirib olish
COPY . .

# 8000-portni ochib qo‘yish
EXPOSE 8000

# Avval create_table.py bajariladi, keyin uvicorn ishga tushadi
CMD ["sh", "-c", "python create_table.py && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"]
