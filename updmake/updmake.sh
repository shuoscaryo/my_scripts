#!/bin/bash

if ! [ -f "Makefile" ]; then
	echo "ERROR: No makefile found in current directory."
	exit 1
fi

if [ $# -ge 1 ]; then
	file_dir=$(cd $1 && pwd)
else
	file_dir=$(pwd)
fi

if [ -h "$0" ]; then
	script_dir=$(dirname $(readlink "$0"))
else
	script_dir=$(cd $(dirname $0) && pwd)
fi

files=$(find $file_dir -type f \( -name "*.c" -o -name "*.cpp" \) | sed "s|$file_dir/||g")

echo "new files:"
for i in $files; do
	echo -e "\t$i"
done

make -C $script_dir > /dev/null 2>&1
echo "Replacing src in Makefile"
$script_dir/replace_src $files
