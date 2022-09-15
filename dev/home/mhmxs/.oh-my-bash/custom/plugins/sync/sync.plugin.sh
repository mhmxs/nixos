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

cleanup() {
    docker rm -f $(docker ps -qa)
    docker system prune -a -f
    docker volume ls -qf dangling=true | xargs -r docker volume rm
    nix-store --optimise
    nix-collect-garbage --delete-old

    PATH=/home/mhmxs/src/github.com/ondat/kubecover/envsetup/bin:$PATH

    for v in `sudo ignite vm -q`; do sudo ignite rm vm $v; done
    for v in `sudo ignite image -q`; do sudo ignite image rm $v; done

    for v in `ls ~/.go`; do sudo rm -rf .go/$v/pkg/mod/; done

    rm -rf $HOME/.cache

    find src -type d -name .git -exec bash -c 'cd {}/.. ; git gc' \;

    df -h
}
