#!/bin/bash
# Abort on Error
set -e

PING_SLEEP=30s
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dump_output() {
   echo " ++ Tailing the last 500 lines of output from $BUILD_OUTPUT"
   tail -500 $BUILD_OUTPUT  
}
error_handler() {
  echo ERROR: An error was encountered with the build.
  kill $PING_LOOP_PID
  dump_output
  exit 1
}
# If an error occurs, run our error handler to output a tail of the build
trap 'error_handler' ERR

# Set up a repeating loop to send some output to Travis.
bash -c "while true; do sleep $PING_SLEEP; echo \" ++ \$(date) - running ... \"; done" &
PING_LOOP_PID=$!
BUILD_OUTPUT=build-$PING_LOOP_PID.out
touch $BUILD_OUTPUT
echo " + $@"
echo " ++ Output redirected to $BUILD_OUTPUT"
$@ >> $BUILD_OUTPUT 2>&1

# The build finished without returning an error so dump a tail of the output
dump_output

# nicely terminate the ping output loop
kill $PING_LOOP_PID