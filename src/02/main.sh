#!/bin/bash

source "check_input.sh"
source "create.sh"

if [ "$#" -ne 3 ]; then
    echo "ERROR: You must provide exactly 3 parameters."
    exit 1
fi

FOLDER_CHARS="$1"
FILE_CHARS="$2"
FILE_SIZE="$3"

LOG_FILE="$(dirname "$0")/log.txt"
> "$LOG_FILE" 

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")

if ! validate_input "$FOLDER_CHARS" "$FILE_CHARS" "$FILE_SIZE"; then
        echo "ERROR: Input is not correct"
        exit 1
    fi

    while true; do
        create_main_folder "$FOLDER_CHARS" "$FILE_CHARS" "$FILE_SIZE"
    done

 
    