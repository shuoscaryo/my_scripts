#!/bin/bash
#This scripts creates a softlink of the .sh parameter in .local/bin so its inside the path
#When running it the first time, use bash ./addscript.sh addscript.sh to add the script in the path
#Then you can do : addscript script.sh

if [ $# -ne 1 ]; then
	echo "Usage: install script_name.sh"
	exit 1
fi

<<<<<<< HEAD
script_dir=$(cd $(dirname "$1");pwd)
cd -
file_name=$(dirname "${1%.sh}")
install_dir=~/.local/bin

echo "script dir" $script_dir
echo "file_name" $file_name
=======
script_dir=$(dirname $(readlink -f "$1"))
file_name=$(basename "${1%.sh}")
install_dir=~/.local/bin

function realpath {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}
>>>>>>> 8abeaf6188c73935a4605789b2f86f1c4d842a63

ln -s $script_dir/$file_name.sh $install_dir/$file_name
chmod +x $install_dir/$file_name
