#!/bin/bash

export LC_ALL=C

fasm main.asm ls > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "compilation failed"
    exit 1
fi

chmod +x ls

myls_out=$(./ls)
myls_exit=$?

if [ $myls_exit -ne 0 ]; then
    echo "myls returned non-zero exit code"
    exit 1
fi

sorted_myls=$(printf '%s\n' "$myls_out" | sort)
sorted_ls=$(command ls -a | sort)

if [ "$sorted_myls" != "$sorted_ls" ]; then
    echo "directory listing mismatch"
    exit 1
fi


if ! printf '%s\n' "$myls_out" | grep -q "main.asm"; then
    echo "Expected file not found in output"
    exit 1
fi

echo "all tests passed successfully"
exit 0
