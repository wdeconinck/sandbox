#!/usr/bin/env bash

owner=$1
repo=$2
branch=$3

if [ -z "${TMPDIR}" ]; then
  TMPDIR=${HOME}/tmp
fi
SOURCE_DIR=${TMPDIR}/downloads/check-git-${repo}

dump_output() {
   echo " ++ Tailing the last 500 lines of output from ${BUILD_OUTPUT}"
   tail -500 ${BUILD_OUTPUT}
}
error_handler() {
  echo ERROR: An error was encountered with the build.
  rm -rf ${SOURCE_DIR}
  dump_output
  exit 1
}
# If an error occurs, run our error handler to output a tail of the build
trap 'error_handler' ERR

BUILD_OUTPUT=$(pwd)/tmp-${repo}.log
touch $BUILD_OUTPUT

git clone --depth=1 -b ${branch} https://github.com/${owner}/${repo} ${SOURCE_DIR} >> ${BUILD_OUTPUT} 2>&1 
cd ${SOURCE_DIR} >> ${BUILD_OUTPUT} 2>&1 
git rev-parse HEAD
cd ..
rm -rf ${SOURCE_DIR}
