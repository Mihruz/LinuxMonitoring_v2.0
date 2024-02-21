#!/bin/bash

function isDigit {
    [[ $1 =~ ^[0-9]+$ ]]
}
function dirName {
    [[ $1 =~ ^[a-zA-Z]{1,7}$ ]]
}
function fileName {
    [[ $1 =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]
}
function size {
    [[ ${1%kb} -le 100  && $1 =~ ^[0-9]{1,3}kb$ ]]
}

if [ ! -d $1 ]; then
    mkdir $1 2>> error.log
fi    

if [ -d $1 ] && isDigit $2 && dirName $3 && isDigit $4 && fileName $5 && size $6; then
    echo "Correct arguments. Running..."
else
    echo "ERROR: Input is not correct"
    exit 1
fi