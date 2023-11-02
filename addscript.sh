#!/bin/bash
#This scripts creates a softlink of the .sh parameter in .local/bin so its inside the path
#When running it the first time, use bash ./addscript.sh addscript.sh to add the script in the path
#Then you can do : addscript script.sh

if [ $# -ne 1 ]; then
	echo "Usage: addscript script_name.sh"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "File $1 does not exist"
	exit 1
fi
if [ ! -x $1 ]; then
	echo "File $1 is not executable"
	exit 1
fi
if [ -h $1 ]; then
	echo "File $1 is already a symbolic link"
	exit 1
fi

cd $(dirname "$1")
script_dir=$(pwd)
cd - > /dev/null 2>&1

file_name=$(basename "${1%.sh}")
install_dir=~/.local/bin

ln -s $script_dir/$file_name.sh $install_dir/$file_name
chmod +x $install_dir/$file_name
