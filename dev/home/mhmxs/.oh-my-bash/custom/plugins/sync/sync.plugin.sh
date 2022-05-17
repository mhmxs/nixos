_backup() {
    export PASSPHRASE="$(hostname)$(hostname)"
    SOURCE=$HOME
    TARGET=scp://readynas@192.168.3.104//media/wd/data/backup/$(hostname)

    duplicity --full-if-older-than 1Y \
        --include-filelist=$HOME/.oh-my-bash/custom/plugins/sync/include \
        --exclude-filelist=$HOME/.oh-my-bash/custom/plugins/sync/exclude \
        $SOURCE $TARGET
    if [[ $? != 0 ]]; then
        echo "Backup failed"
        sleep infinity
    fi
    duplicity verify \
        --include-filelist=$HOME/.oh-my-bash/custom/plugins/sync/include \
        --exclude-filelist=$HOME/.oh-my-bash/custom/plugins/sync/exclude \
        $TARGET $SOURCE
    duplicity remove-older-than 1M --force $TARGET
    duplicity collection-status $TARGET
    echo "duplicity list-current-files $TARGET | less"
}
alias backup=_backup
