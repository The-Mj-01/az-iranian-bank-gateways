# راهنمای سریع Deploy روی Arvan Cloud

## مراحل سریع

### 1. تنظیم Secret برای ghcr.io

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=The-Mj-01 \
  --docker-password=YOUR_GITHUB_TOKEN \
  --docker-email=your-email@example.com
```

### 2. تولید SECRET_KEY و تنظیم secret.yaml

```bash
# تولید SECRET_KEY
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'

# ویرایش secret.yaml و جایگزینی secret-key
# merchant-code و terminal-code از قبل تنظیم شده‌اند
```

### 3. Deploy

```bash
cd k8s
kubectl apply -k .
```

### 4. بررسی وضعیت

```bash
# بررسی pods
kubectl get pods -l app=azbankgateways-test

# بررسی logs
kubectl logs -l app=azbankgateways-test --tail=50 -f
```

### 5. دسترسی با Port Forward

```bash
kubectl port-forward svc/azbankgateways-test-service 8000:80
# سپس به http://localhost:8000 بروید
```

## نکات مهم

1. ✅ حتماً SECRET_KEY را تغییر دهید
2. ✅ Secret برای ghcr.io را ایجاد کنید
3. ✅ Service روی پورت 80 است
4. ✅ تنظیمات بانک از Secret خوانده می‌شوند
