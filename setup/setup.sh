#!/usr/bin/bash

set -e

if [ $# -ne 2 ]; then
	echo "Usage: setup.sh [c|c++] [project_name]"
	exit 1
fi

if [[ $1 =~ ^(c|C)\+\+$ ]]; then
	type="C++"
elif [[ $1 =~ ^(c|C)$ ]]; then
	type="C"
else
	echo "Usage: setup.sh [c|c++] [project_name]"
	exit 1
fi

if ! [[ "$2" =~ ^[a-zA-Z0-9_-]*$ ]]; then
	echo "Project name must only contain alphanumeric characters, underscores, and dashes."
	exit 1
fi

if [[ "$2" =~ \<(\.|\.\.|gist|enterprise|settings|setup|setup\.sh|README\.md|LICENSE|dashboard|pulls|issues|security|actions|packages|topics|pages|marketplace|explore|notifications|new)\> ]]; then
	echo "Project name is a reserved word."
	exit 1
fi

if ! [[ "$2" =~ ^.{1,100}$ ]]; then
	echo "Project name must be between 1 and 100 characters."
	exit 1
fi

#if [ -d "$2" ]; then
#	echo "Project directory already exists."
#	exit 1
#fi

username=$(jq -re '.username' ~/setup/data.json) || exit 1
token=$(jq -re '.token' ~/setup/data.json) || exit 1

echo "Creating $type project template in $PWD/$2"
mkdir -p $2
cd $2
cp ~/setup/Makefile_template Makefile
cp ~/setup/gitignore_template .gitignore
sed -i "s/#NAME/$2/g" Makefile
mkdir -p src include
if [ $type == "C++" ]; then
	sed -i "s/#NAME/$2/g" Makefile
	sed -i "s/#COMPILER/c++/g" Makefile
	sed -i "s/#CPPFLAGS/c++=98/g" Makefile
	sed -i "s/#MAIN/main.cpp/g" Makefile
	touch src/main.cpp
	touch include/$2.hpp
fi
if [ $type == "C" ]; then
	sed -i "s/#COMPILER/gcc/g" Makefile
	sed -i "s/#CPPFLAGS//g" Makefile
	sed -i "s/#MAIN/main.c/g" Makefile
	touch src/main.c
	touch include/$2.h
	cp -r ~/libft/modified/ libft/ >/dev/null 2>/dev/null
fi

#RESPONSE=$(curl -u $username:$token https://api.github.com/user/repos -d "{\"name\":\"$2\"}" 2>/dev/null)
#GITURL=$(jq -r '.html_url' <<< "$RESPONSE")
#echo "$RESPONSE" | grep -q "errors" && status=1 || status=0
#if [ $status -eq 1 ]; then
#	echo "Failed to create repository."
#	echo "$RESPONSE"
#	exit 1
#fi
#git init
#git remote add origin $GITURL
#git branch -M main
#git add .
#git commit -m "Initial commit"
#git push -u origin main
exit 0
