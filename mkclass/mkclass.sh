#!/bin/bash

for i in "$@"; do
	if [[ $i =~ \.hpp$ ]]; then
		name="$i"
	else
		name="$i.hpp"
	fi
	classname=${name%.hpp}
	if [[ -f "$name" ]]; then
		echo "file $name already exists"
	else
		echo "creating file $name"
		touch "$name"
		echo "#pragma once
#include <iostream>

class $classname
{
	public:
		$classname(void);
		$classname(const $classname & src);
		~$classname(void);
		$classname & operator=(const $classname & rhs);
	protected:
	private:
};

std::ostream &operator<<(std::ostream &os, const $classname &obj);" >> "$name"
	fi
	name2=$(echo "$name" | sed "s/\.hpp$/\.cpp/g")
	if [[ -f "$name2" ]]; then
		echo "file $name2 already exists"
		continue
	fi
	echo "creating file $name2"
	touch "$name2"
	echo "#include \"$name\"

$classname::$classname(void)
{
}

$classname::$classname(const $classname & src)
{
	*this = src;
}

$classname::~$classname(void)
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
	os << \"stuff\";
	return (os);
}" >> "$name2"

done