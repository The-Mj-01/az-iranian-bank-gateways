# راهنمای سریع توسعه - Quick Start Guide

## 🚀 شروع سریع

### 1. راه‌اندازی محیط

```bash
# نصب وابستگی‌های توسعه
pip install -e ".[dev]"
pre-commit install
```

### 2. ساختار کلاس BaseBank

هر بانک باید این متدها را پیاده‌سازی کند:

```python
class MyBank(BaseBank):
    # اجباری
    def get_bank_type(self) -> BankType
    def set_default_settings(self)
    def get_pay_data(self) -> dict
    def pay(self)
    def get_verify_data(self) -> dict
    def verify(self, tracking_code)
    def prepare_verify_from_gateway(self)
    def _get_gateway_payment_url_parameter(self) -> str
    def _get_gateway_payment_parameter(self) -> dict
    def _get_gateway_payment_method_parameter(self) -> str
```

### 3. مراحل اضافه کردن بانک جدید

1. ✅ اضافه کردن `BankType` در `models/enum.py`
2. ✅ ایجاد فایل `banks/newbank.py` با کلاس بانک
3. ✅ اضافه کردن import در `banks/__init__.py`
4. ✅ اضافه کردن به `BANK_CLASS` در `default_settings.py`
5. ✅ تست در `settings.py` و view

### 4. چک‌لیست قبل از PR

- [ ] کد با `black` فرمت شده
- [ ] import ها با `isort` مرتب شده
- [ ] `flake8` بدون خطا
- [ ] تمام متدهای abstract پیاده‌سازی شده
- [ ] تست دستی انجام شده
- [ ] مستندات به‌روز شده

### 5. دستورات مفید

```bash
# فرمت کردن کد
black azbankgateways/

# مرتب کردن imports
isort azbankgateways/

# بررسی linting
flake8 azbankgateways/

# اجرای تمام pre-commit hooks
pre-commit run --all-files
```

### 6. مثال ساده

```python
# banks/simplebank.py
from azbankgateways.banks import BaseBank
from azbankgateways.models import BankType, CurrencyEnum, PaymentStatus

class SimpleBank(BaseBank):
    _merchant_code = None
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.set_gateway_currency(CurrencyEnum.IRR)
        self._payment_url = "https://api.example.com/pay"
        self._verify_url = "https://api.example.com/verify"
        self._gateway_url = "https://gateway.example.com"
    
    def get_bank_type(self):
        return BankType.SIMPLEBANK
    
    def set_default_settings(self):
        if "MERCHANT_CODE" not in self.default_setting_kwargs:
            raise SettingDoesNotExist()
        self._merchant_code = self.default_setting_kwargs["MERCHANT_CODE"]
    
    def get_pay_data(self):
        return {
            "merchant": self._merchant_code,
            "amount": self.get_gateway_amount(),
            "callback": self._get_gateway_callback_url(),
            "order_id": self.get_tracking_code(),
        }
    
    def pay(self):
        super().pay()
        # ارسال درخواست به API
        # ذخیره reference_number
    
    def get_verify_data(self):
        return {
            "merchant": self._merchant_code,
            "token": self.get_reference_number(),
        }
    
    def verify(self, tracking_code):
        super().verify(tracking_code)
        # تایید پرداخت
        # تنظیم PaymentStatus
    
    def prepare_verify_from_gateway(self):
        super().prepare_verify_from_gateway()
        # خواندن پارامترهای بازگشتی
    
    def _get_gateway_payment_url_parameter(self):
        return f"{self._gateway_url}/{self.get_reference_number()}"
    
    def _get_gateway_payment_parameter(self):
        return {}
    
    def _get_gateway_payment_method_parameter(self):
        return "GET"
```

---

برای جزئیات بیشتر، فایل `DEVELOPMENT_GUIDE.md` را مطالعه کنید.


