#!/bin/bash

if [ $# != 0 ]; then
    echo "Error: Run without arguments"
else
    goaccess ../04/logs/*.log --log-format=COMBINED --date-format=%d/%b/%Y --time-format=%T --output=report.html
fi