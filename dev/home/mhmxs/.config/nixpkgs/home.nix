{ pkgs, ...}: {
  programs.home-manager.enable = true;

  home.username = "mhmxs";
  home.homeDirectory = "/home/mhmxs";

  home.packages = [
	pkgs.go_1_17
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
        pkgs.bat
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

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.mybashrc
    '';
  };

  programs.direnv = {
	enable = true;
	nix-direnv.enable = true;
	enableBashIntegration = true;
  };
}
