#!/bin/bash

source "analyze.sh"

if [[ $# -ne 1 || ! $1 =~ ^[1-4]$ ]]; then
    echo "Использование: $0 {1|2|3|4}"
    echo "1 - Все записи, отсортированные по коду ответа"
    echo "2 - Все уникальные IP, встречающиеся в записях"
    echo "3 - Все запросы с ошибками (код ответа — 4xx или 5xx)"
    echo "4 - Все уникальные IP, которые встречаются среди ошибочных запросов"
    exit 1
fi

LOG_FILE="*.log"

case $1 in
    1)
        sort_by_status "$LOG_FILE" > result.log
        ;;
    2)
        unique_ips "$LOG_FILE" > result.log
        ;;
    3)
        error_requests "$LOG_FILE" > result.log
        ;;
    4)
        error_ips "$LOG_FILE" > result.log
        ;;
esac

echo "Результат сохранен в файл: result.log"