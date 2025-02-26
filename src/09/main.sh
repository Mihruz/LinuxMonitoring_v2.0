#!/bin/bash

METRICS_FILE="metrics"

get_cpu_usage() {
    cpu_load=$(uptime | awk -F'[a-z]:' '{print $2}' | awk '{print $1}')
    cpu_load=$(echo "$cpu_load" | tr -d ',')
    echo "cpu_load_average $cpu_load"
}

get_memory_usage() {
    total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    free_mem=$(grep MemFree /proc/meminfo | awk '{print $2}')
    used_mem=$((total_mem - free_mem))
    echo "memory_total_bytes $total_mem"
    echo "memory_free_bytes $free_mem"
    echo "memory_used_bytes $used_mem"
}


get_disk_usage() {

    total_disk=$(df / | tail -n1 | awk '{print $2}')
    free_disk=$(df / | tail -n1 | awk '{print $4}')
    used_disk=$((total_disk - free_disk))
    echo "disk_total_bytes $total_disk"
    echo "disk_free_bytes $free_disk"
    echo "disk_used_bytes $used_disk"
}

while true; do
    > "$METRICS_FILE"

    echo "# HELP cpu_load_average CPU load average over 1 minute" >> "$METRICS_FILE"
    echo "# TYPE cpu_load_average gauge" >> "$METRICS_FILE"
    get_cpu_usage >> "$METRICS_FILE"

    echo "# HELP memory_total_bytes Total memory in bytes" >> "$METRICS_FILE"
    echo "# TYPE memory_total_bytes gauge" >> "$METRICS_FILE"
    echo "# HELP memory_free_bytes Free memory in bytes" >> "$METRICS_FILE"
    echo "# TYPE memory_free_bytes gauge" >> "$METRICS_FILE"
    echo "# HELP memory_used_bytes Used memory in bytes" >> "$METRICS_FILE"
    echo "# TYPE memory_used_bytes gauge" >> "$METRICS_FILE"
    get_memory_usage >> "$METRICS_FILE"

    echo "# HELP disk_total_bytes Total disk space in bytes" >> "$METRICS_FILE"
    echo "# TYPE disk_total_bytes gauge" >> "$METRICS_FILE"
    echo "# HELP disk_free_bytes Free disk space in bytes" >> "$METRICS_FILE"
    echo "# TYPE disk_free_bytes gauge" >> "$METRICS_FILE"
    echo "# HELP disk_used_bytes Used disk space in bytes" >> "$METRICS_FILE"
    echo "# TYPE disk_used_bytes gauge" >> "$METRICS_FILE"
    get_disk_usage >> "$METRICS_FILE"

    
    sleep 3
done