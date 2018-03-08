#!/usr/bin/env bash

owner=$1
repo=$2
branch=$3

n=0
until [ $n -ge 5 ]; do
  wget -qO- https://api.github.com/repos/${owner}/${repo}/branches/${branch} | python -c '
import json, sys
try:
  input=sys.stdin.read()
  obj=json.loads(input)
  head_tree_sha = obj["commit"]["sha"]
  print(head_tree_sha)
except:
  sys.exit(1)
' && break
  n=$[$n+1]
  sleep 1
done

#!/bin/bash
# # Abort on Error
# set -e
# GITHUB_USER=$1
# REPO_NAME=$2
# REPO_BRANCH=$3
# wget -qO- https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}/commits/${REPO_BRANCH} | grep sha | head -1 | sed -n 's/.*"\(.*\)",.*/\1/p'
