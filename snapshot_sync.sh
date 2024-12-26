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

  # Вставка нового блока "snapshot_sync" после последней строки в блоке "chain"
  sed -i '/"wallet": {/,/}/{
    /}/a\        "snapshot_sync": {\n          "sleep": 1.5,\n          "batch_size": 10000,\n          "starting_sub_id": 0,\n          "sync_period": 1\n        },
  }' "$file"

  echo "Изменения применены к $file."
}

# Редактирование обоих файлов
edit_config_file "$CONFIG_FILE1"
edit_config_file "$CONFIG_FILE2"

echo "Все изменения успешно применены."
