{ pkgs, ...}: {
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.username = "mhmxs";
  home.homeDirectory = "/home/mhmxs";

  home.packages = [
    pkgs.krunvm
    pkgs.buildah
    pkgs.openvpn
    pkgs.tinyproxy
    pkgs.bind
    pkgs.lsof
    pkgs.nodejs-16_x
    pkgs.gcc
    pkgs.gnumake
    pkgs.git
    pkgs.duplicity
    pkgs.kubectl
    pkgs.kind
    pkgs.tunnelto
    pkgs.k9s
    pkgs.krew
    pkgs.kube-capacity
    pkgs.rake
    pkgs.gh
    pkgs.bat
    pkgs.yq
    pkgs.jq
    pkgs.tldr
    pkgs.lsd
    pkgs.fzf
    pkgs.starship
    pkgs.ripgrep
    pkgs.unzip
    pkgs.diff-so-fancy
    pkgs.lazydocker
    pkgs.colordiff
    pkgs.google-cloud-sdk
    pkgs.awscli
    pkgs.aws-iam-authenticator
    pkgs.eksctl
    pkgs.azure-cli
  ];

  programs.vim = {
    enable = true;
    extraConfig = ''
      set mouse-=a
    '';
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "vim";
      DOCKER_BUILDKIT = "1";
      GOROOT = "$HOME/go";
    };
    shellAliases = {
      ls = "lsd";
      less = "bat";
      man = "tldr";
      diff = "colordiff";
    };
    bashrcExtra = ''
      . ~/.mybashrc
    '';
  };

  home.sessionPath = [
    "/usr/local/bin"
    "$HOME/go/bin"
    "$HOME/.krew/bin"
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };
}
