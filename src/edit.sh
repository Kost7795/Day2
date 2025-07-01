#!/bin/bash

# Проверка количества аргументов
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <file_path> <string_to_replace> <replacement>"
    exit 1
fi

FILE_PATH=$1
OLD_STR=$2
NEW_STR=$3
LOG_FILE="files.log"

# Проверка существования файла
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File $FILE_PATH does not exist"
    exit 1
fi

# Создаем резервную копию файла
BACKUP="${FILE_PATH}.bak"
cp "$FILE_PATH" "$BACKUP"

# Выполняем замену
sed -i "s/${OLD_STR}/${NEW_STR}/g" "$FILE_PATH"

# Проверяем, были ли внесены изменения
if cmp -s "$FILE_PATH" "$BACKUP"; then
    echo "No changes made - string not found"
    rm "$BACKUP"
    exit 0
fi

# Получаем данные для лога
FILE_SIZE=$(stat -c %s "$FILE_PATH")
MOD_DATE=$(stat -c %y "$FILE_PATH")
SHA_SUM=$(sha256sum "$FILE_PATH" | awk '{print $1}')

# Записываем в лог
echo "${FILE_PATH} — ${FILE_SIZE} — ${MOD_DATE} — ${SHA_SUM} — SHA-256" >> "$LOG_FILE"

# Удаляем резервную копию
rm "$BACKUP"

echo "Replacement complete. Log entry added to $LOG_FILE"
