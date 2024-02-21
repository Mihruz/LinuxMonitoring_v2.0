#!/bin/bash

dir=$1
dirNameInput=$3
fileNameInput=$5
dirCount=$2
fileCount=$4
size=$6
extension=$(echo "$fileNameInput" | awk -F '.' '{print $2}')
fileName=${fileNameInput%%.*}

while [ ${#dirNameInput} -le 3 ]; do
    dirNameInput+="${dirNameInput: -1}"
done
if [ ${#fileName} -le 3 ]; then
    fileNameInput="${fileNameInput:0:1}${fileNameInput:0:1}${fileNameInput:0:1}$fileNameInput"
fi
dirName=$dirNameInput
fileName=${fileNameInput%%.*}

date=$(date +%d%m%y)

function dirNameGenerator() {
    local dirNameLocal="$1"
    if [ ${#dirNameLocal} -le 240 ]; then
        dirNameLocal+="${dirNameLocal: -1}"
    else
        dirNameLocal="${dirNameInput:0:1}$dirNameInput"
    fi
    echo "$dirNameLocal"
}

function fileNameGenerator() {
    local fileNameLocal="$1"
    local nameNoExt=${fileNameLocal%%.*}

    if [ ${#nameNoExt} -le 240 ]; then
        nameNoExt+="${nameNoExt: -1}"
        fileNameLocal=$nameNoExt
    else
        fileNameLocal="${fileNameInput:0:1}${fileNameInput%%.*}"
    fi
    echo "$fileNameLocal"
}

for (( i=0; i<$dirCount; i++ )) {
    if [ ! -d "$dirName"_"$date" ]; then
        mkdir "$dir"/"$dirName"_"$date" 2>> error.log
        if [[ -d  "$dir"/"$dirName"_"$date" ]]; then
            echo "$dir"/"$dirName"_"$date"" ""$(date +%F)" >> logs.log
        fi
    fi

    for (( j=0; j<$fileCount; j++ )) {
        checkSpace
        fallocate -l $size "$dir"/"$dirName"_"$date"/"$fileName"_"$date"."$extension" 2>> error.log
        if [[ -f  "$dir"/"$dirName"_"$date"/"$fileName"_"$date"."$extension" ]]; then
            echo "$dir"/"$dirName"_"$date"/"$fileName"_"$date"."$extension"" ""$(date +%F)"" ""$size" >> logs.log
        fi
        fileName=$(fileNameGenerator "$fileName")
    }

    fileName=${fileNameInput%%.*}
    dirName=$(dirNameGenerator "$dirName")
}
