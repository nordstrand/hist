#!/bin/bash

set -e

SCRIPTDIR="$(dirname $0)"
. ${SCRIPTDIR}/util.sh
. ${SCRIPTDIR}/git.sh


GIT_DIR=$(pwd)

while getopts "hC:" opt; do
  case $opt in
    C)
      echo "Processing repo: $OPTARG" >&2
      GIT_DIR="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    h)
      show_help
      exit 0
      ;;
  esac
done 

TAGS=($(getTagsByDate ${GIT_DIR}))
RECENT_DATE=$(getDateForCommit ${GIT_DIR} ${TAGS[0]})

function plot() {
    local gitDir="$1"
    local fromGitRef="$2"
    local toGitRef="$3"
    
    getCommitDates "$gitDir" "$fromGitRef" "$toGitRef" |  while read -r line; do echo $(dateDiff $line $RECENT_DATE); done | gnuplot ${SCRIPTDIR}/git.gp

}



plot ${GIT_DIR} ${TAGS[1]} ${TAGS[0]}
