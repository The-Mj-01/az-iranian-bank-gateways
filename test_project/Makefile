# Makefile برای راحتی استفاده از Docker

.PHONY: help build up down logs shell restart migrate

help:
	@echo "دستورات موجود:"
	@echo "  make build    - ساخت image"
	@echo "  make up       - اجرای کانتینر"
	@echo "  make down     - توقف کانتینر"
	@echo "  make logs     - مشاهده لاگ‌ها"
	@echo "  make shell    - دسترسی به shell"
	@echo "  make restart  - restart کانتینر"
	@echo "  make migrate  - اجرای migration"
	@echo "  make clean    - پاک کردن همه چیز"

build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

shell:
	docker-compose exec web bash

restart:
	docker-compose restart

migrate:
	docker-compose exec web python manage.py migrate

clean:
	docker-compose down -v
	docker system prune -f




