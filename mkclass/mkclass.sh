#!/bin/bash

for i in "$@"; do
	if [[ $i =~ \.hpp$ ]]; then
		name="$i"
	else
		name="$i.hpp"
	fi
	if [[ -f "$name" ]]; then
		echo "file $name already exists"
	else
		echo "creating file $name"
		touch "$name"
		echo "#pragma once

class $i
{
	public:
		$i(void);
		$i(const $i & src);
		~$i(void);
		$i & operator=(const $i & rhs);
	protected:
	private:
};" >> "$name"
	fi
	name2=$(echo "$name" | sed "s/\.hpp$/\.cpp/g")
	if [[ -f "$name2" ]]; then
		echo "file $name2 already exists"
		continue
	fi
	echo "creating file $name2"
	touch "$name2"
	echo "#include \"$name\"

$i::$i(void)
{
}

$i::$i(const $i & src)
{
	*this = src;
}

$i::~$i(void)
{
}

$i & $i::operator=(const $i & rhs)
{
	if (this != &rhs)
	{
		// copy
	}
	return (*this);
}" >> "$name2"

done