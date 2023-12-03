#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <number of nodes>"
	exit 1
fi

if [ -h "$0" ]; then
	script_dir=$(dirname $(readlink "$0"))
else
	script_dir=$(cd $(dirname $0) && pwd)
fi

for ((i=0; i<=$1; i++)); do
	mkdir -p "ex0$i"
	cp "$script_dir/Makefile" "ex0$i/"
	cp "$script_dir/main.cpp" "ex0$i/"
done
