#!/bin/bash

set -e
git add --all
git status -s
git commit -m "."
git push
