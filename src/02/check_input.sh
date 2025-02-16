#!/bin/bash

validate_input() {
    local folder_chars="$1"
    local file_chars="$2"
    local file_size="$3"

    if [[ ! "$folder_chars" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "ERROR: Parameter 1 must contain 1-7 English alphabet letters."
        return 1
    fi

    if [[ ! "$file_chars" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "ERROR: Parameter 2 must contain 1-7 letters for the name and 1-3 letters for the extension."
        return 1
    fi

    if [[ ! "$file_size" =~ ^[0-9]+Mb$ || "${file_size%Mb}" -gt 100 ]]; then
        echo "ERROR: Parameter 3 must be in the format 'XMb' where X is a number <= 100."
        return 1
    fi

    return 0
}