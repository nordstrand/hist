#!/bin/bash

set -e
set -o pipefail

SCRIPTDIR="$(dirname $0)"
. ${SCRIPTDIR}/util.sh
. ${SCRIPTDIR}/git.sh


checkDependenciesInPath git gnuplot

GIT_DIR=$(pwd)

while getopts "hr:n:f:t:C:O:m:x:" opt; do
  case $opt in
    r)
      RELEASE_NAME="$OPTARG"
      ;;
    n)
      REPO_NAME="$OPTARG"
      ;;
    f)
      FROM_REV="$OPTARG"
      ;;
    t)
      TO_REV="$OPTARG"
      ;;
    C)
      GIT_DIR="$OPTARG"
      ;;
    m)
      MAX_DAYS="$OPTARG"
      ;;
    x)
      EXCLUDE_TAGS_FILTER="$OPTARG"
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
    gnuplot <(cat ${SCRIPTDIR}/git.gp | sed\
        -e "s|_outputfile_|$OUTPUT_FILE|"\
        -e "s|_repository_|$REPO_NAME|"\
        -e "s|_release_|$RELEASE_NAME|"\
        -e "s|_maxdays_|$MAX_DAYS|"\
    )
}

function plot() {
    local gitDir="$1"
    local fromGitRef="$2"
    local toGitRef="$3"
    [ -n "$4" ] &&  local baseLineDate="$4" || local baseLineDate="$(getDateForCommit ${GIT_DIR} ${toGitRef})"

    echo "Plotting $fromGitRef..$toGitRef with age baseline $baseLineDate" >&2

    [ -z "$OUTPUT_FILE" ] && OUTPUT_FILE="graph_$baseLineDate.png"
    [ -z "$REPO_NAME" ] && REPO_NAME="$(getRepositoryName $gitDir)"
    [ -z "$RELEASE_NAME" ] && RELEASE_NAME="${toGitRef#refs/tags/}"

    echo "Output:  ${OUTPUT_FILE}" >&2
    echo "Name:    ${REPO_NAME}" >&2
    echo "Release: ${RELEASE_NAME}" >&2

    getCommitDates "$gitDir" "$fromGitRef" "$toGitRef" |  while read -r line; do echo $(dateDiff $line $baseLineDate); done |\
    invokeGnuPlot
    OUTPUT_FILE=""
    RELEASE_NAME=""
}

function plotAllTags() {
    if [ -n "$EXCLUDE_TAGS_FILTER" ]; then
        echo "Excluding tags matching: ${EXCLUDE_TAGS_FILTER}"
        TAGS=($(getTagsByDate ${GIT_DIR} | grep -Ev ${EXCLUDE_TAGS_FILTER}))
    else
        TAGS=($(getTagsByDate ${GIT_DIR}))
    fi

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
