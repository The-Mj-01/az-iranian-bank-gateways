# استفاده از Python 3.11
FROM python:3.11-slim

# تنظیم متغیرهای محیطی
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# تنظیم دایرکتوری کاری
WORKDIR /app

# نصب وابستگی‌های سیستم
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# کپی فایل requirements از test_project
COPY test_project/requirements.txt .

# نصب وابستگی‌های Python
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# کپی کل پروژه اصلی با ساختار صحیح
# ساختار باید باشد: /azbankgateways/azbankgateways/... (پکیج در دایرکتوری والد)
RUN mkdir -p /azbankgateways/azbankgateways
COPY azbankgateways /azbankgateways/azbankgateways
COPY setup.cfg pyproject.toml MANIFEST.in README.md LICENSE /azbankgateways/

# کپی setup.py برای نصب
COPY test_project/setup_azbankgateways.py /azbankgateways/setup.py

# نصب کتابخانه به صورت عادی (نه editable) برای اطمینان از کارکرد
WORKDIR /azbankgateways
RUN pip install . --verbose

# ایجاد فایل marker برای تشخیص اینکه این دایرکتوری از build time است
RUN touch /azbankgateways/.built-in-image

# بازگشت به دایرکتوری اصلی
WORKDIR /app

# کپی فایل‌های پروژه تست
COPY test_project/ .

# کپی و تنظیم اسکریپت راه‌اندازی
COPY test_project/start.sh /start.sh
RUN chmod +x /start.sh

# اکسپوز کردن پورت
EXPOSE 8000

# اجرای سرور
CMD ["/start.sh"]
