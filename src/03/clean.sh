#!/bin/bash

clean_by_log() {
    if [[ ! -f "$LOG_FILE" ]]; then
        echo "ERROR: Log file '$LOG_FILE' not found."
        exit 1
    fi

    echo "Cleaning by log file..."

    while IFS= read -r line; do
        if [[ "$line" == Created* ]]; then
            path=$(echo "$line" | awk -F', ' '{print $1}' | awk '{print $3}')
            if [[ -e "$path" ]]; then
                echo "Removing: $path" >> clean_log.log
                rm -rf "$path"
            else
                echo "Path does not exist: $path"
            fi
        fi
    done < "$LOG_FILE"

    echo "Cleanup by log file completed."
}

clean_by_date() {
    echo "Enter the start time (format: YYYY-MM-DD HH:MM):"
    read -r START_TIME
    echo "Enter the end time (format: YYYY-MM-DD HH:MM):"
    read -r END_TIME

    if ! date -d "$START_TIME" &>/dev/null || ! date -d "$END_TIME" &>/dev/null; then
        echo "ERROR: Invalid date format. Use 'YYYY-MM-DD HH:MM'."
        exit 1
    fi

    START_TIMESTAMP=$(date -d "$START_TIME" +%s)
    END_TIMESTAMP=$(date -d "$END_TIME" +%s)

    echo "Cleaning files created between $START_TIME and $END_TIME..."

    CRITICAL_PATHS=("/" "/home" "/etc" "/bin" "/sbin" "/usr" "/var" "/boot")

    find / \
        -path /proc -prune -o \
        -path /sys -prune -o \
        -path /dev -prune -o \
        -path /run -prune -o \
        -type f -o -type d \
        -print 2>/dev/null | while IFS= read -r path; do

        for critical in "${CRITICAL_PATHS[@]}"; do
            if [[ "$path" == "$critical" || "$path" == "$critical/"* ]]; then
                echo "Skipping critical path: $path" >> skip.log
                continue 2
            fi
        done

        if CREATION_TIME=$(stat -c %Y "$path" 2>/dev/null); then
            if ((CREATION_TIME >= START_TIMESTAMP && CREATION_TIME <= END_TIMESTAMP)); then
                echo "Removing: $path" >> clean_date.log
                rm -rf "$path"
            fi
        fi
    done

    echo "Cleanup by date completed."
}

clean_by_mask() {
    echo "Cleaning by name mask..."

    MASK="*_*[0-9][0-9][0-9][0-9][0-9][0-9]"

    find / -type f -name "$MASK" -o -type d -name "$MASK" 2>/dev/null | while read -r path; do
        if [[ -e "$path" ]]; then

                if [[ "$path" =~ /([^/]+)_([0-9]{6})$ ]]; then
                    echo "Removing: $path" >> clean_mask.log
                    rm -rf "$path"
                else
                    echo "Skipping invalid path: $path" >> clean_mask.log
                fi
            fi
    done

    echo "Cleanup by name mask completed."
}