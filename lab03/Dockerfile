# Базовый образ Пайтон
FROM python:3.12-slim

# Установка зависимостей
RUN apt-get update && \
 apt-get install -y --no-install-recommends cron tzdata && \
 rm -rf /var/lib/apt/lists/*

 # Устанока часового пояса
 ENV TZ=Europe/Chisinau

 # Создание директории для приложения
WORKDIR /app

# Установка зависимостей Python
RUN pip install --no-cache-dir requests

# Копирование скрипта в контейнер
COPY currency_exchange_rate.py /app/
COPY cronjob /etc/cron.d/cronjob
COPY entrypoint.sh /app/

# Даем права на выполнение скрипта и cronjob
RUN chmod 0644 /etc/cron.d/cronjob && \
    chmod +x /app/entrypoint.sh

# Запуск контейнера
ENTRYPOINT ["/app/entrypoint.sh"]