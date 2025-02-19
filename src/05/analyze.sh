#!/bin/bash

sort_by_status() {
    local log_file="$1"
    cat $log_file | awk '{print}' | sort -k9,9n
}

unique_ips() {
    local log_file="$1"
    cat $log_file | awk '{print $1}' | uniq
}

error_requests() {
    local log_file="$1"
    cat $log_file | awk '($9 >= 400 && $9 < 600) {print}' | uniq
}

error_ips() {
    local log_file="$1"
    cat $log_file | awk '($9 >= 400 && $9 < 600)' | awk '{print $1}' | sort | uniq
}