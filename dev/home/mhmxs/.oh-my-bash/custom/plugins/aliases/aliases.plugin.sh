aliases() {
    : ${1?: required}

    query="$@"

    for f in `find ~/.oh-my-bash -name *.aliases.sh`; do
        cat $f | grep "$query"
    done
}