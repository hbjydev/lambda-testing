#!/bin/bash

NODE="${NODE:-$1}"
PYTHON="${NODE:-$2}"
GO="${NODE:-$3}"

# usage: hit <url>
function hit() {
  local url="$1"

  curl -s -w "@curl-format.txt" -o /dev/null "$url" | tail -n 1 | awk '{print $2}' | sed 's/s//'
}

# usage: avg <json array>
function avg() {
  local set="$1"
  echo $set | jq '. | add/length'
}

# usage: round <number> <decimal places>
function round() {
  local n="$1"
  local p="$2"

  local pfmt="%0.$2"
  pfmt+="f"

  printf "$pfmt" $n
}

# usage: csv <json array>
function csv() {
  local set="$1"
  echo $set | jq -r '@csv'
}

csv_cols="name,avg,"

results_node="["
results_python="["
results_go="["

# test 500 times
for i in {1..5}
do
  if [[ $i == 1 ]]; then
    csv_cols+="$i"
    results_node+="$(hit $NODE)"
    results_python+="$(hit $PYTHON)"
    results_go+="$(hit $GO)"
  else
    csv_cols+=",$i"
    results_node+=",$(hit $NODE)"
    results_python+=",$(hit $PYTHON)"
    results_go+=",$(hit $GO)"
  fi
done

results_node+="]"
results_python+="]"
results_go+="]"

echo $csv_cols > out.csv
echo "node,$(round $(avg $results_node) 6),$(csv $results_node)" >> out.csv
echo "python,$(round $(avg $results_python) 6),$(csv $results_python)" >> out.csv
echo "go,$(round $(avg $results_go) 6),$(csv $results_go)" >> out.csv

echo "Average results (to 4dp) per language:"
echo
echo "Node:   avg:$(round $(avg $results_node) 4)s"
echo "Python: avg:$(round $(avg $results_python) 4)s"
echo "Go:     avg:$(round $(avg $results_go) 4)s"
echo
echo "A complete set of results including averages has been written to out.csv."

