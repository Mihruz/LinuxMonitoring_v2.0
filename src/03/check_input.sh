#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "ERROR: You must provide exactly 1 parameter (1, 2, or 3)."
    exit 1
fi