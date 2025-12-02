# راهنمای Deploy روی Arvan Cloud Container Service

این دایرکتوری شامل manifest های Kubernetes برای deploy کردن پروژه تستی روی Arvan Cloud است.

## فایل‌ها

- `deployment.yaml` - تعریف Deployment برای pod ها
- `service.yaml` - Service برای expose کردن سرویس روی پورت 80
- `secret.yaml` - Secret برای اطلاعات حساس (SECRET_KEY، MERCHANT_CODE، TERMINAL_CODE)
- `configmap.yaml` - ConfigMap برای تنظیمات عمومی
- `kustomization.yaml` - فایل Kustomize برای مدیریت همه منابع

## پیش‌نیازها

1. **kubectl** نصب شده باشد
2. **دسترسی به Arvan Cloud Kubernetes cluster** (kubeconfig تنظیم شده باشد)
3. **Image در ghcr.io push شده باشد**

## مراحل Deploy

### 1. تنظیم Secret برای ghcr.io

برای pull کردن image از ghcr.io، باید secret برای registry ایجاد کنید:

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=The-Mj-01 \
  --docker-password=YOUR_GITHUB_TOKEN \
  --docker-email=your-email@example.com
```

### 2. تنظیم Secret

**مهم**: قبل از deploy، حتماً SECRET_KEY را در `secret.yaml` تغییر دهید:

```bash
# تولید SECRET_KEY جدید
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'

# سپس در secret.yaml مقدار secret-key را تغییر دهید
```

مقادیر `merchant-code` و `terminal-code` در `secret.yaml` از قبل تنظیم شده‌اند.

### 3. تنظیم Image

در `deployment.yaml` مطمئن شوید که آدرس image صحیح است:

```yaml
image: ghcr.io/the-mj-01/test-project-web:latest
```

### 4. Deploy کردن

**روش 1: با kustomize (پیشنهادی)**

```bash
cd k8s
kubectl apply -k .
```

**روش 2: با kubectl (تک تک)**

```bash
cd k8s
kubectl apply -f secret.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

**روش 3: همه فایل‌ها با هم**

```bash
cd k8s
kubectl apply -f .
```

### 5. بررسی وضعیت

```bash
# بررسی pods
kubectl get pods -l app=azbankgateways-test

# بررسی services
kubectl get svc -l app=azbankgateways-test

# بررسی logs
kubectl logs -l app=azbankgateways-test --tail=50 -f

# بررسی deployment
kubectl get deployment azbankgateways-test
```

### 6. دسترسی به سرویس

**با Port Forward:**
```bash
kubectl port-forward svc/azbankgateways-test-service 8000:80
# سپس به http://localhost:8000 بروید
```

**با NodePort یا LoadBalancer:**
اگر نیاز به دسترسی از خارج دارید، می‌توانید `service.yaml` را به `LoadBalancer` تغییر دهید:

```yaml
spec:
  type: LoadBalancer
```

## تنظیمات

### Environment Variables

پروژه از environment variables زیر استفاده می‌کند:

- `SECRET_KEY` - از Secret خوانده می‌شود
- `MERCHANT_CODE` - از Secret خوانده می‌شود
- `TERMINAL_CODE` - از Secret خوانده می‌شود
- `DEBUG` - از ConfigMap خوانده می‌شود
- `ALLOWED_HOSTS` - از ConfigMap خوانده می‌شود

### تنظیمات درگاه بانکی

تنظیمات درگاه بانکی از Secret خوانده می‌شوند و در `settings.py` استفاده می‌شوند.

## Troubleshooting

### Pod ها start نمی‌شوند

```bash
# بررسی events
kubectl describe pod <pod-name>

# بررسی logs
kubectl logs <pod-name>
```

### Image Pull Error

```bash
# بررسی secret
kubectl get secret ghcr-secret

# تست pull
kubectl run test-pod --image=ghcr.io/the-mj-01/test-project-web:latest --rm -it --restart=Never
```

### بررسی Environment Variables

```bash
# بررسی env variables در pod
kubectl exec <pod-name> -- env | grep -E "SECRET_KEY|MERCHANT_CODE|TERMINAL_CODE"
```

## حذف Deploy

```bash
# حذف همه منابع
kubectl delete -k .

# یا
kubectl delete -f .
```

## نکات مهم

1. ✅ **SECRET_KEY**: حتماً در production از یک SECRET_KEY امن استفاده کنید
2. ✅ **Secret برای ghcr.io**: حتماً قبل از deploy ایجاد کنید
3. ✅ **Replicas**: روی 1 است (برای تست کافی است)
4. ✅ **Database**: از SQLite استفاده می‌شود (برای تست - داده‌ها با restart pod از بین می‌روند)
