#!/usr/bin/env bash

owner=$1
repo=$2
branch=$3

wget -qO- https://api.github.com/repos/${owner}/${repo}/branches/${branch} | python -c '
import json, sys
obj=json.load(sys.stdin)
head_tree_sha = obj["commit"]["sha"]
print(head_tree_sha)
'

#!/bin/bash
# # Abort on Error
# set -e
# GITHUB_USER=$1
# REPO_NAME=$2
# REPO_BRANCH=$3
# wget -qO- https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}/commits/${REPO_BRANCH} | grep sha | head -1 | sed -n 's/.*"\(.*\)",.*/\1/p'
