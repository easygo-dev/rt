#!/bin/bash

# Пути к файлам конфигурации
CONFIG_FILE1=~/infernet-container-starter/deploy/config.json
CONFIG_FILE2=~/infernet-container-starter/projects/hello-world/container/config.json

# Функция для редактирования конфигурации
edit_config_file() {
  local file=$1
  echo "Редактирую файл: $file"

  # Удаление старого блока "snapshot_sync"
  sed -i '/"snapshot_sync": {/,/}/d' "$file"

  # Корректная вставка блока "snapshot_sync" после закрытия блока "wallet" и перед закрытием блока "chain"
  awk '
    BEGIN { inside_chain = 0 }
    /"chain": {/ { inside_chain = 1 }
    inside_chain && /"wallet": {/,/}/ { print; next } # Пропускаем блок "wallet"
    inside_chain && /^\s*}/ && !printed { 
      printed = 1; 
      print "        \"snapshot_sync\": {\n          \"sleep\": 1.5,\n          \"batch_size\": 10000,\n          \"starting_sub_id\": 0,\n          \"sync_period\": 1\n        }," 
    }
    { print }
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

  echo "Изменения применены к $file."
}

# Редактирование обоих файлов
edit_config_file "$CONFIG_FILE1"
edit_config_file "$CONFIG_FILE2"

echo "Все изменения успешно применены."
