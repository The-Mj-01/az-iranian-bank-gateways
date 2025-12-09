# راهنمای استفاده از Docker

این راهنما نحوه استفاده از Docker برای اجرای پروژه تست را توضیح می‌دهد.

## 📋 پیش‌نیازها

- Docker installed
- Docker Compose installed

## 🚀 روش 1: استفاده از Docker Compose (پیشنهادی)

### ساخت و اجرای کانتینر:

```bash
cd test_project
docker-compose up --build
```

### اجرا در پس‌زمینه:

```bash
docker-compose up -d --build
```

### توقف کانتینر:

```bash
docker-compose down
```

### مشاهده لاگ‌ها:

```bash
docker-compose logs -f
```

### دسترسی به shell داخل کانتینر:

```bash
docker-compose exec web bash
```

## 🔧 روش 2: استفاده مستقیم از Dockerfile

### ساخت image:

```bash
cd test_project
docker build -t sep-test:latest -f Dockerfile .
```

**نکته:** این دستور باید از دایرکتوری `test_project` اجرا شود و context باید دایرکتوری والد باشد.

### اجرای کانتینر:

```bash
docker run -d \
  --name sep-test \
  -p 8000:8000 \
  -v $(pwd)/../azbankgateways:/azbankgateways \
  -v $(pwd):/app \
  sep-test:latest
```

### مشاهده لاگ‌ها:

```bash
docker logs -f sep-test
```

### توقف کانتینر:

```bash
docker stop sep-test
docker rm sep-test
```

## ⚙️ تنظیمات

### تغییر پورت:

در `docker-compose.yml`، خط `ports` را تغییر دهید:

```yaml
ports:
  - "8080:8000"  # پورت 8080 در host به 8000 در container
```

### تغییر تنظیمات Django:

فایل `sep_test/settings.py` را ویرایش کنید. تغییرات به صورت خودکار اعمال می‌شود (به دلیل volume mount).

### استفاده از Dockerfile ساده:

اگر می‌خواهید از کتابخانه نصب شده از PyPI استفاده کنید (نه از حالت توسعه):

```bash
docker build -t sep-test:latest -f Dockerfile.simple .
```

## 🔍 عیب‌یابی

### مشکل: "Cannot find module azbankgateways"

**راه‌حل:** بررسی کنید که کتابخانه به درستی نصب شده باشد:

```bash
docker-compose exec web pip list | grep az-iranian-bank-gateways
```

### مشکل: تغییرات در کد اعمال نمی‌شود

**راه‌حل:** کانتینر را restart کنید:

```bash
docker-compose restart
```

یا اگر از volume mount استفاده می‌کنید، بررسی کنید که volume ها به درستی mount شده باشند.

### مشکل: Migration اجرا نمی‌شود

**راه‌حل:** به صورت دستی اجرا کنید:

```bash
docker-compose exec web python manage.py migrate
```

## 📝 نکات مهم

1. **Volume Mounting:** در `docker-compose.yml`، پروژه اصلی mount شده است تا تغییرات زنده اعمال شوند.

2. **Database:** فایل `db.sqlite3` در volume نگهداری می‌شود تا داده‌ها حفظ شوند.

3. **Environment Variables:** می‌توانید متغیرهای محیطی را در `docker-compose.yml` اضافه کنید:

```yaml
environment:
  - DEBUG=True
  - SECRET_KEY=your-secret-key
```

4. **Hot Reload:** برای تغییرات زنده در کد، از volume mount استفاده کنید.

## 🎯 دسترسی به اپلیکیشن

پس از اجرای کانتینر، به آدرس زیر دسترسی دارید:

```
http://localhost:8000/
```

## 🛑 توقف کامل

برای توقف و حذف همه چیز:

```bash
docker-compose down -v  # حذف volume ها هم
```

یا برای Docker ساده:

```bash
docker stop sep-test
docker rm sep-test
docker rmi sep-test:latest
```

---

**موفق باشید! 🐳**




