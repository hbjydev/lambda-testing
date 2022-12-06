#!/bin/bash

NODE="${NODE:-$1}"
PYTHON="${NODE:-$2}"
GO="${NODE:-$3}"

function hit() {
  local url="$1"

  curl -s -w "@curl-format.txt" -o /dev/null "$url" | tail -n 1 | awk '{print $2}'
}

echo "Node:   $(hit $NODE)"
echo "Python: $(hit $PYTHON)"
echo "Go:     $(hit $GO)"

