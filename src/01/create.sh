#!/bin/bash

generate_unique_name() {
    local chars="$1"
    local min_length=4
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


create_folders_and_files() {
    local base_path="$1"
    local num_folders="$2"
    local folder_chars="$3"
    local num_files="$4"
    local file_chars="$5"
    local file_size="$6"
    local date="$7"

    local size_kb="${file_size%kb}"
    local folder_name_prefix=""
    local file_name_prefix=""
    local extension=""

    file_name_prefix="${file_chars%.*}"
    extension=".${file_chars##*.}"

    local log_buffer=""

    local used_folder_names=""

    for ((i = 1; i <= num_folders; i++)); do
        folder_name_prefix=$(generate_unique_name "$folder_chars" "$used_folder_names")
        folder_name="${folder_name_prefix}_${date}"
        folder_path="${base_path}/${folder_name}"

        used_folder_names+=" $folder_name_prefix "

        mkdir -p "$folder_path"
        log_buffer+="Created folder: $folder_path "$(date +"%F %T")"\n"


        local used_file_names=""

        for ((j = 1; j <= num_files; j++)); do
            file_name=$(generate_unique_name "$file_name_prefix" "$used_file_names")
            file_path="${folder_path}/${file_name}${extension}"

            used_file_names+=" $file_name "

            dd if=/dev/zero of="$file_path" bs=1K count="$size_kb" 2>/dev/null
            log_buffer+="Created file: $file_path, Size: ${size_kb}KB "$(date +"%F %T")"\n"
        done
    done


    echo -e "$log_buffer" >> "$LOG_FILE"
}