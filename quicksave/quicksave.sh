#!/bin/bash

set -e

if [ $# -ge 1 ]; then
	MSG=$*
else
	MSG="quicksave"
fi

git add --all
git status -s
date=$(date +"%Y-%m-%d-%H:%M")
curr_branch=$(git branch | grep "\*" | cut -d ' ' -f2 )
git commit -m "[$curr_branch]<$date> $MSG"
git push
