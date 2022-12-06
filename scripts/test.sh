#!/bin/bash

NODE=""
PYTHON=""
GO=""

echo "Node"
curl -w "@curl-format.txt" -o /dev/null "$NODE" | tail -n 1

echo "Python"
curl -w "@curl-format.txt" -o /dev/null "$PYTHON" | tail -n 1

echo "Go"
curl -w "@curl-format.txt" -o /dev/null "$GO" | tail -n 1

