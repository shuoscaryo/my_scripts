#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <number of nodes>"
	exit 1
fi

script_dir=$(dirname $0)

for ((i=0; i<=$1; i++)); do
	mkdir -p "ex0$i"
	cp "$script_dir/Makefile" "ex0$i/"
done
