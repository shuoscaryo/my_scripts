#!/bin/bash

for i in "$@"; do
	filename=${i%.*}
	classname=$(basename "$filename")
	headerfile=$filename.hpp
	if [[ -f "$headerfile" ]]; then
		echo "file $headerfile already exists"
	else
		echo "creating file $headerfile"
		#touch "$headerfile"
		echo "#pragma once
#include <iostream>

class $classname
{
	public:
		// Constructors and destructor
		$classname(void);
		$classname(const $classname & src);
		~$classname();

		// Getters and setters
		
		// Member functions

		// Operator overloads
		$classname & operator=(const $classname & rhs);
	protected:
	private:

	friend std::ostream &operator<<(std::ostream &os, const $classname &obj);
};

std::ostream &operator<<(std::ostream &os, const $classname &obj);" >> "$headerfile"
	fi
	srcfile=$filename.cpp
	if [[ -f "$srcfile" ]]; then
		echo "file $srcfile already exists"
		continue
	fi
	echo "creating file $srcfile"
	#touch "$srcfile"
	echo "#include \"$classname.hpp\"

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
}" >> "$srcfile"

done