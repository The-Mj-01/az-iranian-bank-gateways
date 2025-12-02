#!/bin/bash
set -e

# نصب مجدد کتابخانه اگر volume mount شده باشد
if [ -d "/azbankgateways" ] && [ -f "/azbankgateways/azbankgateways/__init__.py" ]; then
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
    
    # نصب کتابخانه
    # ابتدا uninstall می‌کنیم تا مطمئن شویم که نصب تمیز است
    pip uninstall -y az-iranian-bank-gateways 2>/dev/null || true
    
    # استفاده از نصب عادی به جای editable برای اطمینان از کارکرد
    pip install . --quiet || pip install . --verbose || true
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

