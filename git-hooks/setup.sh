#! /usr/bin/env bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf ${SCRIPTDIR}/pre-commit ${SCRIPTDIR}/../.git/hooks/pre-commit
