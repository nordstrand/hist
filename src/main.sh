#!/bin/bash

set -e

SCRIPTDIR="$(dirname $0)"
. ${SCRIPTDIR}/util.sh
. ${SCRIPTDIR}/git.sh

GIT_DIR=$1

TAGS=($(getTagsByDate ${GIT_DIR}))

echo ${TAGS[0]}
echo ${TAGS[1]}


RECENT_DATE=$(getDateForCommit ${GIT_DIR} ${TAGS[0]})

getCommitDates ${GIT_DIR} ${TAGS[1]} ${TAGS[0]} |  while read -r line; do echo $(dateDiff $line $RECENT_DATE); done | gnuplot ${SCRIPTDIR}/git.gp


 

