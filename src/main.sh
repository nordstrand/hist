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


function plot() {
    local gitDir="$1"
    local fromGitRef="$2"
    local toGitRef="$3"
    
    getCommitDates "$gitDir" "$fromGitRef" "$toGitRef" |  while read -r line; do echo $(dateDiff $line $RECENT_DATE); done | gnuplot ${SCRIPTDIR}/git.gp

}


 

plot ${GIT_DIR} ${TAGS[1]} ${TAGS[0]}
