#!/bin/bash

freeSize=$(df / | awk 'NR == 2 {print $4}')

function checkSpace {
    if [[ $freeSize -le 1048576 ]]; then
        echo "STOP: Memory is less than or equal to 1 gb"
        exit 1
    fi
}