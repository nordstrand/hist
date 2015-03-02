#!/usr/bin/env bats

. src/git.sh

@test "getTagsByDate should return git tags sorted by date in repo" {
  result=($(getTagsByDate test/testrepo))

    [ ${result[0]} = "refs/tags/release-2.0" ]
    [ ${result[1]} = "refs/tags/release-1.0" ]
}


@test "getCommitDates should return YYYY-MM-DD dates for commits between refs" {
    result=($(getCommitDates test/testrepo HEAD~3 HEAD))

    [ ${result[0]} = "2015-02-28" ]
    [ ${result[1]} = "2015-02-27" ]
    [ ${result[2]} = "2015-02-27" ]
}


@test "getDateForCommit should return YYYY-MM-DD date for commit" {
    result="$(getDateForCommit test/testrepo HEAD~3)"
echo "=========== $result"
    [ ${result} = "2015-02-27" ]
}