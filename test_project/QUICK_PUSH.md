# راهنمای سریع Push به GitHub Container Registry

## 1. ساخت Image

```bash
cd test_project
./build_and_push.sh v1.0.0
```

## 2. Login (فقط یک بار)

ابتدا یک Personal Access Token از اینجا بسازید:
https://github.com/settings/tokens

دسترسی `write:packages` را فعال کنید.

سپس:
```bash
echo YOUR_TOKEN | docker login ghcr.io -u The-Mj-01 --password-stdin
```

## 3. Push

```bash
docker push ghcr.io/the-mj-01/az-iranian-bank-gateways-test:latest
docker push ghcr.io/the-mj-01/az-iranian-bank-gateways-test:v1.0.0
```

## 4. Public کردن (اختیاری)

https://github.com/users/The-Mj-01/packages

---

**یا استفاده از GitHub Actions (خودکار):**

فقط کافی است فایل `.github/workflows/docker-build-push.yml` را commit کنید و push کنید!
