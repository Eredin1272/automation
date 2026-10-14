#!/bin/sh

# Содается файл где бует храниться вывод и ошибки скрипта
create_log_file(){
    echo "Creating log file..."
    touch /var/log/cron.log
    chmod 666 /var/log/cron.log
    echo "Log file created at /var/log/cron.log"
}

# tail -f - позволяет непрерывно отслежтвать изменение в файле, в данном случае в файле /var/log/cron.log
monitor_logs() {
    echo "Monitoring cron logs"
    tail -f /var/log/cron.log
}

# cron -f - запускает планировщик на переднем плане, чтобы контейнер не завершился сразу после запуска
run_cron() {
    echo "Starting cron daemon..."
    exec cron -f
}

# Сохраняются переменные окружения.
env > /etc/environment

create_log_file # Создаётся журнал логов.
monitor_logs & # Запускается наблюдение за журналом в фоне (&)
run_cron # Запускается Cron.

