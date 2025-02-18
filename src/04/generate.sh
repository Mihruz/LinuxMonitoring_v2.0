#!/bin/bash

generate_ip() {
    echo "$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"
}

generate_log_line() {
    local timestamp=$1
    local log_date=$(date -d "@$timestamp" +"%d/%b/%Y:%H:%M:%S")
    
    echo "$(generate_ip) - - [${log_date} +0000] \
\"${methods[$RANDOM % 5]} ${urls[$RANDOM % 7]} HTTP/1.1\" ${status_codes[$RANDOM % 10]} \
$((RANDOM%9000 + 100)) \"-\" \"${user_agents[$RANDOM % 8]}\""
}

methods=("GET" "POST" "PUT" "PATCH" "DELETE")
status_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
user_agents=("Mozilla" "Google Chrome" "Opera" "Safari" 
            "Internet Explorer" "Microsoft Edge" 
            "Crawler and bot" "Library and net tool")
urls=("/" "/page.html" "/api/data" "/image.jpg" 
      "/contact" "/about" "/private")

# Коды ответа HTTP с пояснениями:
# 200 OK - Успешный запрос. Пример: страница загружена, файл скачан, или данные получены.
# 201 Created - Ресурс успешно создан. Пример: Пользователь создал новую запись через POST-запрос.
# 4xx: Ошибки клиента
# 400 Bad Request - Сервер не может обработать запрос из-за синтаксической ошибки. Пример: некорректные параметры в URL или теле запроса.
# 401 Unauthorized - Требуется аутентификация. Пример: пользователь не предоставил логин и пароль.
# 403 Forbidden - Доступ к ресурсу запрещён, даже если пользователь аутентифицирован. Пример: пользователь не имеет прав на доступ к файлу.
# 404 Not Found - Ресурс не найден. Пример: пользователь запросил несуществующую страницу.
# 5xx: Ошибки сервера
# 500 Internal Server Error - Ошибка сервера. Пример: ошибка в коде приложения или конфигурации сервера.
# 501 Not Implemented - Метод не поддерживается. Пример: запрос метода, который сервер не реализует (например, PATCH).
# 502 Bad Gateway - Ошибка шлюза. Пример: проблемы с бэкендом.
# 503 Service Unavailable - Сервис временно недоступен. Пример: сайт временно отключен для технических работ.