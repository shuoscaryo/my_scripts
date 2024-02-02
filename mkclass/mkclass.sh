#!/bin/bash

checkResponse()
{
	while true; do
		read -r response
		if [[ $response =~ ^[yY]$ ]]; then
			echo "y"
			break
		elif [[ $response =~ ^[nN]$ ]]; then
			echo "n"
			break
		fi
	done

	return 0
}

createFile()
{
	# Check number of arguments
	if [ $# -ne 2 ]; then
		echo "Usage: createFile filename content"
		return 1
	fi

	# If the file already exists, ask the user if they want to overwrite it
	if [[ -f "$1" ]]; then
		echo -e "file $1 already exists. Overwrite? (y/n): \c"
		if [[ $(checkResponse) == "n" ]]; then
			return 1
		fi
	fi

	# Create the file
	echo "Creating file $1"
	echo "$2" > "$1"

	return 0
}

# For each argument, create a .hpp and .cpp file with the same name
for i in "$@"; do
	# Get the filename without the extension
	filename=${i%.*}
	classname=$(basename $filename)
	# Remove the path from the filename (eg. ./src/ClassName.cpp -> ClassName.cpp)
	## HEADER FILE CONTENT VARIABLE
	headercontent="#pragma once
#include <iostream>

class $classname
{
	public:
	// Constructors and destructor
		$classname(void);
		$classname(const $classname & src);
		~$classname();

	// Setters and getters
		
	// Member functions

	// Operator overloads
		$classname & operator=(const $classname & rhs);
	protected:
	private:

	friend std::ostream &operator<<(std::ostream &os, const $classname &obj);
};

std::ostream &operator<<(std::ostream &os, const $classname &obj);"

	## SOURCE FILE CONTENT VARIABLE
	srccontent="#include \"$classname.hpp\"

$classname::$classname(void)
{
}

$classname::$classname(const $classname & src)
{
	*this = src;
}

$classname::~$classname()
{
}

$classname &$classname::operator=(const $classname &rhs)
{
	if (this != &rhs)
	{
		// copy
	}
	return (*this);
}

std::ostream &operator<<(std::ostream &os, const $classname &obj)
{
	(void)obj;
	return (os);
}"

	createFile "$filename.hpp" "$headercontent"
	createFile "$filename.cpp" "$srccontent"
done
