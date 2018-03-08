#!/bin/bash
# Abort on Error
set -ex
GITHUB_USER=$1
REPO_NAME=$2
REPO_BRANCH=$3
wget -qO- https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}/commits/${REPO_BRANCH} | grep sha
wget -qO- https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}/commits/${REPO_BRANCH} | grep sha | head -1
wget -qO- https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}/commits/${REPO_BRANCH} | grep sha | head -1 | sed -n 's/.*"\(.*\)",.*/\1/p'
wget -qO- https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}/commits/${REPO_BRANCH} | grep sha | head -1 | sed -n 's/.*"(.*)",.*/\1/p'
