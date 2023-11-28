#!/bin/bash

set -e
 
date=$(date +"%Y-%m-%d-%H:%M")
curr_branch=$(git branch | grep "\*" | cut -d ' ' -f2 )
git add --all
git status -s
git commit -m "[$curr_branch]<$date>"
git push
