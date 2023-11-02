#!/bin/bash

if [ $# -ge 1 ]; then
	file_dir=$(cd $1; pwd)
	cd -
else
	file_dir=$(pwd)
fi

if [ -h "$0" ]; then
	script_dir=$(dirname $(readlink "$0"))
else
	cd $(dirname $0)
	script_dir=$(pwd)
	cd - > /dev/null 2>&1
fi

echo $script_dir

files=$(find $file_dir -type f -regex ".*\.\(c\|cpp\)$" | sed "s|$file_dir/||g")

echo "new files:"
for i in $files; do
	echo -e "\t$i"
done

make -C $script_dir > /dev/null 2>&1
echo "Replacing src in Makefile"
$script_dir/replace_src $files
