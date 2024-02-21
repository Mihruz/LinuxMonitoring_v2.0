#!/bin/bash

cat /dev/null > logs.log
cat /dev/null > error.log

source check_input.sh
source check_space.sh
source create.sh

echo "Done"
echo "Logs: $(wc -l logs.log | awk '{print $1}')"
echo "Errors: $(wc -l error.log | awk '{print $1}')"
