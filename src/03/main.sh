#!/bin/bash

source "check_input.sh"
source "clean.sh"


CLEAN_METHOD="$1"

LOG_FILE="log.txt"


main() {
    case "$CLEAN_METHOD" in
        1)
            clean_by_log
            ;;
        2)
            clean_by_date
            ;;
        3)
            clean_by_mask
            ;;
        *)
            echo "ERROR: Invalid parameter. Use 1 (log), 2 (date), or 3 (mask)."
            exit 1
            ;;
    esac
}

main