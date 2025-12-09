# راهنمای Push کردن Docker Image به GitHub Container Registry (ghcr.io)

## پیش‌نیازها

1. **Docker نصب شده باشد**
2. **GitHub Personal Access Token (PAT)** با دسترسی‌های زیر:
   - `write:packages` - برای push کردن packages
   - `read:packages` - برای خواندن packages

## مراحل

### 1. ساخت GitHub Personal Access Token

1. به آدرس زیر بروید:
   ```
   https://github.com/settings/tokens
   ```

2. روی "Generate new token" > "Generate new token (classic)" کلیک کنید

3. یک نام برای token انتخاب کنید (مثلاً: `ghcr-docker-push`)

4. دسترسی‌های زیر را انتخاب کنید:
   - ✅ `write:packages`
   - ✅ `read:packages`

5. روی "Generate token" کلیک کنید

6. **مهم**: Token را کپی کنید و در جای امنی نگه دارید (فقط یک بار نمایش داده می‌شود)

### 2. روش اول: استفاده از اسکریپت (پیشنهادی)

```bash
# از دایرکتوری test_project
cd test_project

# اجرای اسکریپت (با version پیش‌فرض: latest)
./push_to_ghcr.sh

# یا با version مشخص
./push_to_ghcr.sh v1.0.0
```

اسکریپت از شما GitHub Token را می‌خواهد. می‌توانید آن را به صورت environment variable هم تنظیم کنید:

```bash
export GITHUB_TOKEN=your_token_here
./push_to_ghcr.sh v1.0.0
```

### 3. روش دوم: دستورات دستی

#### مرحله 1: Build کردن image

از دایرکتوری root پروژه (یک سطح بالاتر از `test_project`):

```bash
cd /Users/ramzinex/PycharmProjects/az-iranian-bank-gateways
docker build -f test_project/Dockerfile -t test-project-web:latest .
```

#### مرحله 2: Tag کردن image برای ghcr.io

```bash
docker tag test-project-web:latest ghcr.io/the-mj-01/test-project-web:latest
```

**نکته**: نام image باید به این صورت باشد:
- `ghcr.io/[username]/[image-name]:[tag]`
- username: نام کاربری GitHub شما (`The-Mj-01`)
- image-name: نام image (می‌توانید هر نامی انتخاب کنید)
- tag: نسخه image (مثلاً `latest`, `v1.0.0`, `1.0.0`)

#### مرحله 3: Login به ghcr.io

```bash
# روش 1: با استفاده از PAT
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u The-Mj-01 --password-stdin

# روش 2: بدون echo (بعد از اجرا از شما password می‌خواهد)
docker login ghcr.io -u The-Mj-01
# Password: [paste your GitHub PAT here]
```

#### مرحله 4: Push کردن image

```bash
docker push ghcr.io/the-mj-01/test-project-web:latest
```

### 4. بررسی نتیجه

بعد از push موفق، می‌توانید package را در GitHub مشاهده کنید:

1. به صفحه profile خود بروید:
   ```
   https://github.com/The-Mj-01?tab=packages
   ```

2. یا مستقیماً به آدرس package:
   ```
   https://github.com/users/The-Mj-01/packages/container/package/test-project-web
   ```

## استفاده از Image

بعد از push، می‌توانید image را pull کنید:

```bash
# Login (اگر قبلاً login نکرده‌اید)
docker login ghcr.io -u The-Mj-01

# Pull image
docker pull ghcr.io/the-mj-01/test-project-web:latest

# Run container
docker run -p 8000:8000 ghcr.io/the-mj-01/test-project-web:latest
```

## نکات مهم

1. **نام image**: نام image در ghcr.io باید با حروف کوچک باشد (`the-mj-01` نه `The-Mj-01`)

2. **Visibility**: به صورت پیش‌فرض package شما **private** است. برای public کردن:
   - به صفحه package بروید
   - روی "Package settings" کلیک کنید
   - در بخش "Danger Zone" روی "Change visibility" کلیک کنید

3. **Versioning**: بهتر است از tag‌های معنادار استفاده کنید:
   ```bash
   docker tag test-project-web:latest ghcr.io/the-mj-01/test-project-web:v1.0.0
   docker push ghcr.io/the-mj-01/test-project-web:v1.0.0
   ```

4. **Security**: هرگز GitHub Token را در کد یا repository commit نکنید!

## مثال کامل

```bash
# از root directory پروژه
cd /Users/ramzinex/PycharmProjects/az-iranian-bank-gateways

# Build
docker build -f test_project/Dockerfile -t test-project-web:v1.0.0 .

# Tag
docker tag test-project-web:v1.0.0 ghcr.io/the-mj-01/test-project-web:v1.0.0
docker tag test-project-web:v1.0.0 ghcr.io/the-mj-01/test-project-web:latest

# Login
echo YOUR_TOKEN | docker login ghcr.io -u The-Mj-01 --password-stdin

# Push
docker push ghcr.io/the-mj-01/test-project-web:v1.0.0
docker push ghcr.io/the-mj-01/test-project-web:latest
```

## عیب‌یابی

### خطای Authentication
```
Error response from daemon: unauthorized
```
**راه حل**: مطمئن شوید که PAT شما صحیح است و دسترسی‌های لازم را دارد.

### خطای Permission
```
denied: permission_denied
```
**راه حل**: مطمئن شوید که PAT شما دسترسی `write:packages` دارد.

### خطای Name
```
invalid reference format
```
**راه حل**: مطمئن شوید که نام image با فرمت صحیح است: `ghcr.io/username/image-name:tag`
