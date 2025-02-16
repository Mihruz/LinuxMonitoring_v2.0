#!/bin/bash

source "check_input.sh"
source "create.sh"

if [ "$#" -ne 6 ]; then
    echo "ERROR: You must provide exactly 6 parameters."
    exit 1
fi


BASE_PATH="$1"
NUM_FOLDERS="$2"
FOLDER_CHARS="$3"
NUM_FILES="$4"
FILE_CHARS="$5"
FILE_SIZE="$6"


if ! validate_input "$BASE_PATH" "$NUM_FOLDERS" "$FOLDER_CHARS" "$NUM_FILES" "$FILE_CHARS" "$FILE_SIZE"; then
    echo "ERROR: Input is not correct"
    exit 1
fi


LOG_FILE="$(dirname "$0")/log.txt"
> "$LOG_FILE" 


DATE=$(date +"%d%m%y")


mkdir -p "$BASE_PATH"

create_folders_and_files "$BASE_PATH" "$NUM_FOLDERS" "$FOLDER_CHARS" "$NUM_FILES" "$FILE_CHARS" "$FILE_SIZE" "$DATE"

echo "Script completed successfully. Check the log file: $LOG_FILE"