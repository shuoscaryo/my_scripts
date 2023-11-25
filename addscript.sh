#!/bin/bash
#This scripts creates a softlink of the .sh parameter in .local/bin so its inside the path
#When running it the first time, use bash ./addscript.sh addscript.sh to add the script in the path
#Then you can do : addscript script.sh

#This variable can be changed to another path
install_dir=~/.local/bin

if [ $# -ne 1 ]; then
	echo "Usage: addscript script_name.sh"
	exit 1
fi

script_dir=$(cd $(dirname "$1") && pwd)
file_name=$(basename "${1%.*}")

if [ -f $install_dir/$file_name ]; then
	echo "Link $install_dir/$file_name already exists"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "File $1 does not exist"
	exit 1
fi

if [ ! -x $1 ]; then
	echo "File $1 is not executable"
	while true; do
		read -p "Do you want to add execute flag to the script? [y/n]" answer
		if [[ "$answer" =~ (y|Y) || "$answer" =~ (n|N) ]]; then
			break
		fi
		echo "Wrong answer!"
	done
	if [[ "$answer" =~ (y|Y) ]]; then
		echo "adding execution permission to file $1"
		chmod +x $1
	else
		echo "That's sad :( Ending program"
		exit 0
	fi
fi

if [ -h $1 ]; then
	echo "File $1 is already a symbolic link"
	exit 1
fi

ln -s $script_dir/$file_name.sh $install_dir/$file_name
chmod +x $install_dir/$file_name
echo "Script $file_name added to path"
