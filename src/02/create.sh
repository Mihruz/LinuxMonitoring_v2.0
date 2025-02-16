#!/bin/bash

generate_unique_name() {
    local chars="$1"
    local min_length=5
    local used_names="$2" 

    local base_name=""
    for ((i = 0; i < ${#chars}; i++)); do
        base_name+="${chars:$i:1}"
    done

    while (( ${#base_name} < min_length )); do
        index=$((RANDOM % ${#chars}))
        base_name+="${chars:$index:1}"
    done

    local ordered_name=""
    for ((i = 0; i < ${#base_name}; i++)); do
        char="${base_name:$i:1}"
        if [[ "$ordered_name" != *"$char"* ]]; then
            ordered_name+="$char"
        else
            for ((j = 0; j < ${#chars}; j++)); do
                if [[ "${chars:$j:1}" == "$char" ]]; then
                    ordered_name+="$char"
                    break
                fi
            done
        fi
    done


    while [[ " $used_names " == *" $ordered_name "* ]]; do
        index=$((RANDOM % ${#chars}))
        ordered_name+="${chars:$index:1}"
    done

    echo "$ordered_name"
}


get_random_path() {
    local mount_points=($(df | awk 'NR > 1 && $6 !~ /\/bin|\/sbin|\/snap|\/sys/ {print $6}'))

    local random_index=$((RANDOM % ${#mount_points[@]}))
    echo "${mount_points[$random_index]}"
}

is_writable() {
    local path="$1"
    if [ -w "$path" ]; then
        return 0 
    else
        return 1 
    fi
}

check_free_space() {
    available_space=$(df / | awk 'NR==2 {print $4}')
    if ((available_space <= 1048576)); then
        echo "Stopped due to insufficient disk space (<1GB)."
        END_TIME=$(date +"%Y-%m-%d %H:%M:%S")


    START_SECONDS=$(date -d "$START_TIME" +%s)
    END_SECONDS=$(date -d "$END_TIME" +%s)
    TOTAL_TIME=$((END_SECONDS - START_SECONDS))


    echo -e "\nStart time: $START_TIME\nEnd time: $END_TIME\nTotal execution time: ${TOTAL_TIME} seconds" >> "$LOG_FILE"

    echo "Script completed successfully."
    echo "Start time: $START_TIME"
    echo "End time: $END_TIME"
    echo "Total execution time: ${TOTAL_TIME} seconds"
    exit 0
    fi
    
}

create_nested_folders_and_files() {
    
    local folder_path="$1"
    local folder_chars="$2"
    local file_chars="$3"
    local file_size="$4"
    local size_mb="${file_size%Mb}"
    local date=$(date +"%d%m%y")
    local log_buffer=""

    local file_name_prefix="${file_chars%.*}"
    local extension=".${file_chars##*.}"

    for ((j = 1; j <= 100; j++)); do
   
        available_spac=$(df / | awk 'NR==2 {print $4}')
        echo "DEBUG: Available space: ${available_spac} KB"

        local nested_folder_name_prefix=$(generate_unique_name "$folder_chars" "")
        local nested_folder_name="${nested_folder_name_prefix}_${date}"
        local nested_folder_path="${folder_path}/${nested_folder_name}"

        mkdir -p "$nested_folder_path"
        log_buffer+="Created nested folder: $nested_folder_path "$(date +"%F %T")"\n"

        local num_files=$((RANDOM % 10 + 1))
        local used_file_names=""

        for ((k = 1; k <= num_files; k++)); do
        
        check_free_space
         
            local file_name=$(generate_unique_name "$file_name_prefix" "$used_file_names")
            local file_path="${nested_folder_path}/${file_name}${extension}"

            used_file_names+=" $file_name "

            # fallocate -l "${size_mb}M" "$file_path"
            dd if=/dev/zero of="$file_path" bs=1M count="$size_mb" 2>/dev/null
            log_buffer+="Created file: $file_path, Size: ${size_mb}MB "$(date +"%F %T")"\n"

            
            
        done
    done

    echo -e "$log_buffer" >> "$LOG_FILE"
}

create_main_folder() {
    
    local folder_chars="$1"
    local file_chars="$2"
    local file_size="$3"
    local date=$(date +"%d%m%y")
    local log_buffer=""

    local base_path=$(get_random_path)


    if ! is_writable "$base_path"; then
        echo "ERROR: Path '$base_path' is not writable. Skipping this path."
        return
    fi

    local folder_name_prefix=$(generate_unique_name "$folder_chars" "")
    local folder_name="${folder_name_prefix}_${date}"
    local folder_path="${base_path}/${folder_name}"


    mkdir -p "$folder_path"
    log_buffer+="Created main folder: $folder_path "$(date +"%F %T")"\n"

    create_nested_folders_and_files "$folder_path" "$folder_chars" "$file_chars" "$file_size"

    echo -e "$log_buffer" >> "$LOG_FILE"
}