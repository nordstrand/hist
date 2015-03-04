#!/bin/bash

set -e

SCRIPTDIR="$(dirname $0)"
. ${SCRIPTDIR}/util.sh
. ${SCRIPTDIR}/git.sh


checkDependenciesInPath git gnuplot

GIT_DIR=$(pwd)
OUTPUT_FILE="graph.png"

while getopts "hC:O:" opt; do
  case $opt in
    C)
      GIT_DIR="$OPTARG"
      ;;
    O)
      OUTPUT_FILE="$OPTARG"
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

echo "Repo:   ${GIT_DIR}" >&2
echo "Output: ${OUTPUT_FILE}" >&2


function invokeGnuPlot {
    gnuplot <(cat ${SCRIPTDIR}/git.gp | sed "s/_outputfile_/${OUTPUT_FILE}/")
}

function plot() {
    local gitDir="$1"
    local fromGitRef="$2"
    local toGitRef="$3"
    [ -n "$4" ] &&  local baseLineDate="$4" || local baseLineDate="$(getDateForCommit ${GIT_DIR} ${toGitRef})"

    getCommitDates "$gitDir" "$fromGitRef" "$toGitRef" |  while read -r line; do echo $(dateDiff $line $baseLineDate); done |\
    invokeGnuPlot
}


TAGS=($(getTagsByDate ${GIT_DIR}))
plot ${GIT_DIR} ${TAGS[1]} ${TAGS[0]}
