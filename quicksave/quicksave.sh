#!/bin/bash

set -e
 
git add --all
git status -s
date=$(date +"%Y-%m-%d-%H:%M")
curr_branch=$(git branch | grep "\*" | cut -d ' ' -f2 )
git commit -m "[$curr_branch]<$date> quicksave"
git push
