#!/bin/bash

set -e

# Parse options of command
# -n: do not execute git add --all
GITADD=true
while getopts ":nh" opt; do
	case $opt in
		n)
			GITADD=false
			;;
		h)
			echo "Usage: quicksave [-n] [message]"
			echo "  -n: do not execute git add --all"
			echo "  message: commit message"
			echo "  If message is not specified, the default message is 'quicksave'"
			exit 0
			;;
		\?)
			echo "Options:"
			echo "  -n: do not execute git add --all"
			echo "  -h: show help"
			exit 1
			;;
	esac
done
# This command shift the index of arguments to ignore the options
# If it is not used, $* will contain the options
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
