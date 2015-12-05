
function die() { echo "$@"; exit 1; }

function timeStampFromDateString() {
    if [ "$(uname)" == "Darwin" ]; then
		echo $(date -j -f "%Y-%M-%d" "$1" "+%s")
	else
		echo $(date --date="$1" +%s)
	fi
}

function dateDiff() {
    local fromDate=$(timeStampFromDateString $1)
    local toDate=$(timeStampFromDateString $2)
    
    [[ $toDate < $fromDate ]] && die "$1 is after $2"
    
    
    echo $(( (${toDate} - ${fromDate})/(60*60*24) ))
}

function checkDependenciesInPath() {
    local deps="$@"
    for dep in $deps
    do
        local path_to_executable=$(which $dep)
        if [ -x "$path_to_executable" ] ; then
            true;
        else
            die "$dep not found in PATH"
        fi
    done
}

function show_help() {
cat << EOF
 -f <frevision>
     First revision of development cycle
 -t <trevision>
     Last revision of development cycle
 -C <path>
     Process repository in <path>
 -n <name>
     Repository name, defaults to top-level folder name
 -r <release>
     Release name, defaults to <trevision>
 -O <file>
     Write graph to <file>
 -h 
     Show help
EOF
}
