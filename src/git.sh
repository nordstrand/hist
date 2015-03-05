
function assertGitRepo() {
    local gitDir="$1"
    
    [ -d "$gitDir/.git" ] || { echo "No git repository found in $gitDir" ; exit; }
    
}


function getTagsByDate() {
    local gitDir="$1"
    
    assertGitRepo "$gitDir"
    
    git -C "$gitDir" for-each-ref \
    --format='%(*committerdate:raw)%(committerdate:raw) %(refname) %(*objectname) ' refs/tags |\
    sort -rn | awk '{print $3}'
}


function getCommitDates() {
    local gitDir="$1"
    local fromGitRef="$2"
    local toGitRef="$3"
    
    assertGitRepo "$gitDir"
    
    git -C "$gitDir" log --format=%ad --date=short "$fromGitRef..$toGitRef"
}


function getDateForCommit() {
    local gitDir="$1"
    local gitRef="$2"
    
    assertGitRepo "$gitDir"

    git -C "$gitDir" log --format=%ad --date=short -1 "${gitRef}"
}
