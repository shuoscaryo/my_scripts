#!/bin/bash

if [ $# -ge 1 ]; then
	file_dir=$(realpath $1)
else
	file_dir=$(pwd)
fi

curr_dir=$(dirname $0)
files=$(find $file_dir -type f -regex ".*\.\(c\|cpp\)$" | sed "s|$file_dir/||g")

echo "new files:"
for i in $files; do
	echo -e "\t$i"
done

make -C $curr_dir > /dev/null 2>&1
echo "Replacing src in Makefile"
$curr_dir/replace_src $files
