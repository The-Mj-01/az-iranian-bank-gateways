#!/bin/bash

# اسکریپت راه‌اندازی پروژه تست

echo "🚀 راه‌اندازی پروژه تست درگاه بانک سامان..."

# بررسی وجود Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 یافت نشد. لطفاً Python را نصب کنید."
    exit 1
fi

# ایجاد محیط مجازی (در صورت نیاز)
if [ ! -d "venv" ]; then
    echo "📦 ایجاد محیط مجازی..."
    python3 -m venv venv
fi

# فعال‌سازی محیط مجازی
echo "🔧 فعال‌سازی محیط مجازی..."
source venv/bin/activate

# نصب وابستگی‌ها
echo "📥 نصب وابستگی‌ها..."
pip install --upgrade pip
pip install -r requirements.txt

# نصب کتابخانه از حالت توسعه
echo "📚 نصب کتابخانه az-iranian-bank-gateways از حالت توسعه..."
pip install -e ../

# اجرای Migration
echo "🗄️  اجرای Migration..."
python manage.py migrate

echo ""
echo "✅ راه‌اندازی کامل شد!"
echo ""
echo "📝 مراحل بعدی:"
echo "1. فایل sep_test/settings.py را باز کنید"
echo "2. کدهای MERCHANT_CODE و TERMINAL_CODE را وارد کنید"
echo "3. سرور را اجرا کنید: python manage.py runserver"
echo "4. به آدرس http://127.0.0.1:8000/ بروید"
echo ""


