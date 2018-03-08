#!/usr/bin/env bash

owner=$1
repo=$2
branch=$3


dump_output() {
   echo " ++ Tailing the last 500 lines of output from $BUILD_OUTPUT"
   tail -500 $BUILD_OUTPUT  
}
error_handler() {
  echo ERROR: An error was encountered with the build.
  dump_output
  exit 1
}
# If an error occurs, run our error handler to output a tail of the build
trap 'error_handler' ERR

BUILD_OUTPUT=$(pwd)/tmp-${repo}.log
touch $BUILD_OUTPUT

git clone --depth=1 -b ${branch} https://github.com/${owner}/${repo} tmp-${repo} >> $BUILD_OUTPUT 2>&1 
cd tmp-${repo} >> $BUILD_OUTPUT 2>&1 
git rev-parse HEAD
cd ..
rm -rf tmp-${repo}*

#
# n=0
# until [ $n -ge 5 ]; do
#   wget -qO- https://api.github.com/repos/${owner}/${repo}/branches/${branch} | python -c '
# import json, sys
# try:
#   input=sys.stdin.read()
#   obj=json.loads(input)
#   head_tree_sha = obj["commit"]["sha"]
#   print(head_tree_sha)
# except:
#   sys.exit(1)
# ' && break
#   n=$[$n+1]
#   sleep 1
# done

#!/bin/bash
# # Abort on Error
# set -e
# GITHUB_USER=$1
# REPO_NAME=$2
# REPO_BRANCH=$3
# wget -qO- https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}/commits/${REPO_BRANCH} | grep sha | head -1 | sed -n 's/.*"\(.*\)",.*/\1/p'
