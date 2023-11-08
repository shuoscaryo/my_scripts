#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <number of nodes>"
	exit 1
fi

if [ -h "$0" ]; then
	script_dir=$(dirname $(readlink "$0"))
else
	cd $(dirname $0)
	script_dir=$(pwd)
	cd - > /dev/null 2>&1
fi

for ((i=0; i<=$1; i++)); do
	mkdir -p "ex0$i"
	cp "$script_dir/Makefile" "ex0$i/"
done
