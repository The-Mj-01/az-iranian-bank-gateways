# تغییرات اصلاح درگاه بانک سامان (SEP)

## مشکل
خطای "ترمینال به این نسخه از درگاه پرداخت دسترسی ندارد" به دلیل استفاده از نسخه قدیمی MobilePG به جای OnlinePG

## تغییرات انجام شده

### 1. تغییر URL API از MobilePG به OnlinePG
- **قبل**: `https://sep.shaparak.ir/MobilePG/MobilePayment`
- **بعد**: `https://sep.shaparak.ir/onlinepg/onlinepg`

### 2. اصلاح استفاده از TerminalCode
- **قبل**: استفاده از `self._merchant_code` برای `TerminalId`
- **بعد**: استفاده از `self._terminal_code` برای `TerminalId` در متد `get_pay_data()`

### 3. تغییر فرمت ارسال داده
- **قبل**: ارسال داده به صورت JSON (`json=data`)
- **بعد**: ارسال داده به صورت form-data (`data=data`) مطابق با مستندات OnlinePG

### 4. اصلاح متد verify
- **قبل**: استفاده از `self._merchant_code` در متد `get_verify_data()`
- **بعد**: استفاده از `self._terminal_code` در متد `get_verify_data()`

## فایل‌های تغییر یافته
- `azbankgateways/banks/sep.py`

## تست
- [ ] تست دریافت توکن از درگاه
- [ ] تست هدایت به صفحه پرداخت
- [ ] تست بازگشت از درگاه
- [ ] تست تایید پرداخت

## مراجع
- Issue #158: https://github.com/ali-zahedi/az-iranian-bank-gateways/issues/158
- مستندات SEP OnlinePG در پوشه `sep-docs/`


