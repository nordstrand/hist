#!/bin/bash

set -e
set -o pipefail

SCRIPTDIR="$(dirname $0)"
. ${SCRIPTDIR}/util.sh
. ${SCRIPTDIR}/git.sh


checkDependenciesInPath git gnuplot

GIT_DIR=$(pwd)

while getopts "hf:t:C:O:" opt; do
  case $opt in
    f)
      FROM_REV="$OPTARG"
      ;;
    t)
      TO_REV="$OPTARG"
      ;;
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


function invokeGnuPlot {
    gnuplot <(cat ${SCRIPTDIR}/git.gp | sed "s/_outputfile_/${OUTPUT_FILE}/")
}

function plot() {
    local gitDir="$1"
    local fromGitRef="$2"
    local toGitRef="$3"
    [ -n "$4" ] &&  local baseLineDate="$4" || local baseLineDate="$(getDateForCommit ${GIT_DIR} ${toGitRef})"
    
    echo "Plotting $fromGitRef..$toGitRef with age baseline $baseLineDate" >&2

    [ -z "$OUTPUT_FILE" ] && OUTPUT_FILE="graph_$baseLineDate.png"
    echo "Output: ${OUTPUT_FILE}" >&2
    
    getCommitDates "$gitDir" "$fromGitRef" "$toGitRef" |  while read -r line; do echo $(dateDiff $line $baseLineDate); done |\
    invokeGnuPlot
    OUTPUT_FILE=""
}

function plotAllTags() {
    TAGS=($(getTagsByDate ${GIT_DIR}))
    
    for a in $(seq 0 ${#TAGS[@]}); do 
        if [ -n "${TAGS[$a]}" ] && [ -n "${TAGS[$(($a + 1))]}" ]; then
            plot ${GIT_DIR} ${TAGS[$(($a + 1))]} ${TAGS[$a]}
        fi
    done
}


if [ -z "$FROM_REV" ]; then
    plotAllTags
else
    plot ${GIT_DIR} ${FROM_REV} ${TO_REV}
fi