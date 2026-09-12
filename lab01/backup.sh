#!/bin/bash

if [ -z "${1}" ]; then

echo "Error: source directory was not specifed."
echo "Usage: $0 <source_directory> [backup_directory]"
exit 1

fi


# В этом блоке получаем аргументы
SOURCE_DIR="$1"

if [ "$#" -eq 2 ]; then
BACKUP_DIR="${2}"
else
BACKUP_DIR="/backup"
fi
# Если не будет передан второй аргумент, бэкап будет сохранен по пути /back>


# Проверка существования исходной директории
if [ ! -d "${SOURCE_DIR}" ]; then
echo "Error: source directory does not exist."
exit 1
fi


# Проверка существования директории для бэкапа
if [ ! -d "${BACKUP_DIR}" ]; then
echo "Error: backup directory does not exists."
exit 1
fi

# получение даты
date=$(date +%Y-%m-%d)

# Создание имени архива
ARCHIVE="$BACKUP_DIR/backup_$date.tar.gz"

# Создание архива и копирование
tar -czf "$ARCHIVE" "$SOURCE_DIR"
# -c - create, -z - gzip, -f - имя файла архива

if [ "$?" -eq 0 ]; then
echo "Backup successful: ${ARCHIVE}"
else
echo "Backup failed!"
exit 1
fi