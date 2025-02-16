#!/bin/bash

validate_input() {
    local base_path="$1"
    local num_folders="$2"
    local folder_chars="$3"
    local num_files="$4"
    local file_chars="$5"
    local file_size="$6"

    if [[ ! "$num_folders" =~ ^[0-9]+$ || "$num_folders" -le 0 ]]; then
        echo "ERROR: Parameter 2 must be a positive integer."
        return 1
    fi

    if [[ ! "$folder_chars" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "ERROR: Parameter 3 must contain 1-7 English alphabet letters."
        return 1
    fi

    if [[ ! "$num_files" =~ ^[0-9]+$ || "$num_files" -le 0 ]]; then
        echo "ERROR: Parameter 4 must be a positive integer."
        return 1
    fi

    if [[ ! "$file_chars" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "ERROR: Parameter 5 must contain 1-7 letters for the name and 1-3 letters for the extension."
        return 1
    fi

    if [[ ! "$file_size" =~ ^[0-9]+kb$ || "${file_size%kb}" -gt 100 ]]; then
        echo "ERROR: Parameter 6 must be in the format 'Xkb' where X is a number <= 100."
        return 1
    fi

    return 0
}