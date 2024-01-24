#!/bin/bash

# SETUP THE SCRIPT
# Get the directory where this script is located
# If it is a symlink, get the directory where the symlink points to
if [ -h "$0" ]; then
	script_dir=$(dirname $(readlink "$0"))
# If it is not a symlink, get the directory where the script is located
else
	script_dir=$(cd $(dirname $0) && pwd)
fi
# Compile the program that will replace the src in the makefile
if ! make -C $script_dir > /dev/null 2>&1; then
	echo "ERROR: Could not execute Make in the directory of the script ($script_dir)."
	exit 1
fi

# EXECUTE THE SCRIPT
# Don't execute if there is no makefile in the current directory
if ! [ -f "Makefile" ]; then
	echo "ERROR: No makefile found in current directory."
	exit 1
fi

current_dir=$(pwd)

if [ $# -eq 0 ]; then
	files=$(find $current_dir -type f \( -name "*.c" -o -name "*.cpp" \) | sed "s|$current_dir/||g")
else
	for i in $@; do
		if ! [ -d $i ]; then
			echo "ERROR: $i is not a directory."
			continue
		fi
		file_dir=$(cd $i && pwd)
		# Add the files found to the variable and remove the current directory from the path
		# Also add a newline at the end of each file
		files+="$(find $file_dir -type f \( -name "*.c" -o -name "*.cpp" \) | sed "s|$current_dir/||g")"$'\n'
	done
fi

# Sort and remove duplicates
files=$(echo "$files" | sort -u)

# Print the files that will be replaced
echo "new files:"
for i in $files; do
	echo -e "\t$i"
done

# Replace the src in the makefile
echo "Replacing src in Makefile"
$script_dir/replace_src $files
