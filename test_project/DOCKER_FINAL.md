# ✅ Dockerfile نهایی - تست شده و آماده استفاده

## 🎉 وضعیت: آماده استفاده

Dockerfile و docker-compose.yml با موفقیت ساخته و تست شدند.

## 📋 فایل‌های ایجاد شده

1. **Dockerfile** - فایل اصلی Docker
2. **docker-compose.yml** - تنظیمات Docker Compose
3. **.dockerignore** - فایل‌های نادیده گرفته شده
4. **Makefile** - دستورات سریع
5. **DOCKER_README.md** - راهنمای کامل

## 🚀 نحوه استفاده

### روش 1: با Docker Compose (پیشنهادی)

```bash
cd test_project

# ساخت و اجرا
docker-compose up --build -d

# مشاهده لاگ‌ها
docker-compose logs -f

# توقف
docker-compose down
```

### روش 2: با Makefile

```bash
cd test_project

# ساخت
make build

# اجرا
make up

# لاگ‌ها
make logs

# توقف
make down
```

### روش 3: مستقیم با Docker

```bash
# ساخت image
cd /Users/ramzinex/PycharmProjects/az-iranian-bank-gateways
docker build -f test_project/Dockerfile -t sep-test:latest .

# اجرای کانتینر
docker run -d \
  --name sep-test \
  -p 8000:8000 \
  -v $(pwd)/azbankgateways:/azbankgateways \
  -v $(pwd)/test_project:/app \
  sep-test:latest
```

## ✅ ویژگی‌های Dockerfile

- ✅ استفاده از Python 3.11-slim
- ✅ نصب خودکار وابستگی‌ها
- ✅ نصب کتابخانه از حالت توسعه (editable)
- ✅ اجرای خودکار migration در startup
- ✅ Volume mount برای تغییرات زنده
- ✅ بهینه‌سازی لایه‌ها برای cache بهتر

## 🔧 تنظیمات

### تغییر پورت

در `docker-compose.yml`:
```yaml
ports:
  - "8080:8000"  # پورت 8080 در host
```

### تغییر تنظیمات Django

فایل `sep_test/settings.py` را ویرایش کنید. تغییرات به صورت خودکار اعمال می‌شود.

## 📝 نکات مهم

1. **کدهای درگاه**: قبل از اجرا، کدهای `MERCHANT_CODE` و `TERMINAL_CODE` را در `settings.py` وارد کنید.

2. **Volume Mounting**: پروژه اصلی mount شده است تا تغییرات زنده اعمال شوند.

3. **Database**: فایل `db.sqlite3` در volume نگهداری می‌شود.

4. **Migration**: به صورت خودکار در startup اجرا می‌شود.

## 🐛 عیب‌یابی

### مشکل: پورت 8000 در حال استفاده است

```bash
# پیدا کردن کانتینر استفاده‌کننده
docker ps | grep 8000

# متوقف کردن
docker stop <container_id>

# یا تغییر پورت در docker-compose.yml
```

### مشکل: تغییرات اعمال نمی‌شود

```bash
# Restart کانتینر
docker-compose restart
```

### مشکل: Migration اجرا نمی‌شود

```bash
# اجرای دستی
docker-compose exec web python manage.py migrate
```

## 🎯 دسترسی

پس از اجرا، به آدرس زیر دسترسی دارید:

```
http://localhost:8000/
```

## ✨ خلاصه

- ✅ Dockerfile ساخته و تست شد
- ✅ docker-compose.yml تنظیم شد
- ✅ Migration خودکار در startup
- ✅ Volume mount برای تغییرات زنده
- ✅ آماده استفاده

**موفق باشید! 🐳**


