fasm myls.asm myls > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "compilation failed"
    exit 1
fi

myls_out=$(./myls)
myls_exit=$?

if [ $myls_exit -ne 0 ]; then
    echo "myls returned non-zero exit code"
    exit 1
fi

sorted_myls=$(echo "$myls_out" | sort)
sorted_ls=$(ls -a | sort)

if [ "$sorted_myls" != "$sorted_ls" ]; then
    echo "directory listing mismatch"
    exit 1
fi

if ! echo "$myls_out" | grep -q "myls.asm"; then
    echo "myls.asm not found in output"
    exit 1
fi

echo "all tests passed successfully"
exit 0
