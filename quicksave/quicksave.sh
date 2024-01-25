#!/bin/bash

set -e

GITADD=true
while getopts ":n" opt; do
	case $opt in
		n)
			GITADD=false
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			;;
	esac
done

shift $((OPTIND - 1))

if [ $# -ge 1 ]; then
	MSG=$*
else
	MSG="quicksave"
fi

if [ $GITADD = true ]; then
	git add --all
fi
git status -s
date=$(date +"%Y-%m-%d-%H:%M")
curr_branch=$(git branch | grep "\*" | cut -d ' ' -f2 )
git commit -m "[$curr_branch]<$date> $MSG"
git push
