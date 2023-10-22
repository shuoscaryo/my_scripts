#!/bin/bash

if [ $# -ge 1 ]; then
	file_dir=$(realpath $1)
else
	file_dir=$(pwd)
fi

files=$(find $file_dir -type f -regex ".*\.\(c\|cpp\)$" | sed "s|$file_dir/||g")

echo "new files:"
for i in $files; do
	echo -e "\t$i"
done

make -C $HOME/scripts/updmake > /dev/null 2>&1
echo "Replacing src in Makefile"
$HOME/scripts/updmake/replace_src $files
