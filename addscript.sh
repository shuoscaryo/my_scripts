#!/bin/bash
#This scripts creates a softlink of the .sh parameter in .local/bin so its inside the path
#When running it the first time, use bash ./addscript.sh addscript.sh to add the script in the path
#Then you can do : addscript script.sh

if [ $# -ne 1 ]; then
	echo "Usage: install script_name.sh"
	exit 1
fi

echo $(readlink "$1")
script_dir=$(dirname $(readlink "$1"))
file_name="${1%.sh}"
install_dir=~/.local/bin

echo "script dir" $script_dir
echo "file_name" $file_name
exit 0
ln -s $script_dir/$file_name.sh $install_dir/$file_name
chmod +x $install_dir/$file_name
