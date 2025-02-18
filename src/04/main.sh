#!/bin/bash

source "generate.sh"


mkdir -p logs

for days_ago in {0..4}; do
    filename="logs/access_$(date -d "-${days_ago} days" +"%Y-%m-%d").log"
    entries=$((RANDOM%901 + 100))
    start_time=$(date -d "today -${days_ago} days 00:00" +%s)   
    echo "Генерация ${entries} записей в ${filename}"
    
    for ((i=0; i<entries; i++)); do
        increment=$((RANDOM * RANDOM % 86400))
        timestamp=$((start_time + increment))
        printf "%d|%s\n" "$timestamp" "$(generate_log_line $timestamp)"
    done | sort -t'|' -k1n | cut -d'|' -f2 > "$filename"
done

echo "Логи успешно сгенерированы"