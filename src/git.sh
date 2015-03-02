function getTagsByDate() {

    local gitDir="$1"
    
    git -C "$gitDir" for-each-ref \
    --format='%(*committerdate:raw)%(committerdate:raw) %(refname) %(*objectname) ' refs/tags |\
    sort -rn | awk '{print $3}'
}


function getCommitDates() {

    local gitDir="$1"
    local fromGitRef="$2"
    local toGitRef="$3"
    
    git -C "$gitDir" log --format=%ad --date=short "$fromGitRef..$toGitRef"
}


function getDateForCommit() {

    local gitDir="$1"
    local gitRef="$2"

    git -C "$gitDir" show --quiet --pretty=format:%ad --date=short "$gitRef"
}
