#!/bin/bash

# Пути к файлам конфигурации
CONFIG_FILE1=~/infernet-container-starter/deploy/config.json
CONFIG_FILE2=~/infernet-container-starter/projects/hello-world/container/config.json

# Функция для исправления JSON
fix_json() {
    local file=$1
    echo "Обрабатываю файл: $file"

    awk '
    BEGIN { inside_wallet = 0 }
    # Найти начало блока "wallet"
    /"wallet": {/ { inside_wallet = 1 }
    # Найти конец блока "wallet" и вставить "snapshot_sync" после него
    inside_wallet && /^\s*}/ {
        inside_wallet = 0
        print
        print "        \"snapshot_sync\": {"
        print "          \"sleep\": 1.5,"
        print "          \"batch_size\": 10000,"
        print "          \"starting_sub_id\": 0,"
        print "          \"sync_period\": 1"
        print "        }"
        next
    }
    # Удалить старый блок "snapshot_sync", если он есть
    !inside_wallet && /"snapshot_sync": {/,/}/ { next }
    { print }
    ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

    echo "Изменения в $file завершены."
}

# Исправить оба файла
fix_json "$CONFIG_FILE1"
fix_json "$CONFIG_FILE2"

echo "Исправления завершены."
