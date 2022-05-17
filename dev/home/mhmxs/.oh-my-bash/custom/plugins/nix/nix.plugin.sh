export NIXPKGS_ALLOW_INSECURE=1

. /home/mhmxs/.nix-profile/etc/profile.d/nix.sh

alias ns=nix-shell

nixgen() {
    pushd ~/.oh-my-bash/custom/plugins/nix
        nix-shell --command '. /home/mhmxs/.nix-profile/etc/profile.d/nix.sh ; echo export PATH=$PATH' > ~/.path
    popd
}

nixedit() {
    pushd ~/.oh-my-bash/custom/plugins/nix
        rm -rf ~/.path
        $EDITOR shell.nix
    popd
}