#!/bin/bash
set -e

# نصب مجدد کتابخانه فقط اگر volume mount شده باشد (برای development)
# در Kubernetes/production، کتابخانه از قبل در image نصب شده است
# چک می‌کنیم که آیا فایل marker وجود دارد - اگر نبود یعنی volume mount شده است
if [ -d "/azbankgateways" ] && [ -f "/azbankgateways/azbankgateways/__init__.py" ] && [ ! -f "/azbankgateways/.built-in-image" ]; then
    echo "Detected volume mount for /azbankgateways, reinstalling library..."
    cd /azbankgateways

    # ساخت setup.py اگر وجود نداشته باشد
    if [ ! -f setup.py ]; then
        cat > setup.py << 'PYEOF'
from setuptools import setup, find_packages
import re
import os

def get_version():
    init_file = os.path.join(os.path.dirname(__file__), 'azbankgateways', '__init__.py')
    if os.path.exists(init_file):
        with open(init_file, 'r') as f:
            content = f.read()
            match = re.search(r'__version__\s*=\s*["\']([^"\']+)["\']', content)
            if match:
                return match.group(1)
    return '1.0.0'

setup(
    name='az-iranian-bank-gateways',
    version=get_version(),
    packages=find_packages(),
    install_requires=[
        'six',
        'Django>=3.0',
        'pycryptodome>=3.9.7',
        'zeep',
        'requests',
    ],
)
PYEOF
    fi

    # نصب کتابخانه (بدون uninstall - چون ممکن است در production باشد)
    pip install . --quiet --force-reinstall --no-deps || pip install . --verbose || true
else
    echo "No volume mount detected, using pre-installed library from image..."
fi

# بررسی اینکه پکیج قابل import است
python3 -c "import azbankgateways; print(f'azbankgateways imported successfully, version: {azbankgateways.__version__}')" || {
    echo "ERROR: azbankgateways cannot be imported!"
    echo "Python path:"
    python3 -c "import sys; print('\n'.join(sys.path))"
    echo "Installed packages:"
    pip list | grep az || echo "No az packages found"
    exit 1
}

# بازگشت به دایرکتوری اصلی
cd /app

# پاک کردن Python cache برای اطمینان از استفاده از نسخه جدید
find . -type d -name __pycache__ -exec rm -r {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true

# بررسی نهایی که پکیج قابل import است
python3 -c "import azbankgateways; print('azbankgateways imported successfully')" || {
    echo "ERROR: azbankgateways cannot be imported!"
    echo "Python path:"
    python3 -c "import sys; print('\n'.join(sys.path))"
    echo "Installed packages:"
    pip list | grep az || echo "No az packages found"
    exit 1
}

# اجرای Migration
python manage.py migrate --noinput

# اجرای سرور
exec python manage.py runserver 0.0.0.0:8000
