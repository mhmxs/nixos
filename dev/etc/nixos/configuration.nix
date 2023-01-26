# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "overlay" "kvm-intel" "uio" "tcm_loop" "target_core_mod" "target_core_user" ];
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableOnBoot = true;
  };
  virtualisation.containerd.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mhmxs = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "wheel" "docker" "libvirtd" "vboxusers" ];
      openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAQEegZ89+oYcWf8le3SxyvSdiQUhkp5SfhUdltf78lxWlUVnHrsfLfRfAX2CnRKndnXjKj0ScaAGq2+duqKVTyVQrqtYvb9xC7kQMwMq2Z0SjPATN1EaKm6FQnLAZsw4Q6uKEuXVCEQ0s7bbz3z8f6YXG3sAno8cciuLDTiMjtu/O/71yfrRmG29vs5kvl/k1lX9OfquWlHIOhjREO3y0BNN9K6WjnCgAdEsJZdJ+PPTFq/2ciWqrVxi29ooGZ4lhmUDAzJnSD4btHjuh33FnuDGi7IfHbX9jOUsxRyDG+huwh3hSP/gV4Va1jdBqijswha9uWAwioA0HyLMgrmqD rkovacs@Richard-Kovacs-MBP.local"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    glibc
    gcc
    vim
    mc
    file
    htop
    ctop
    pciutils
    usbutils
    virt-manager
    home-manager
    direnv
    nix-direnv
    cifs-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    openFirewall = true;
    permitRootLogin = "no";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  networking.extraHosts = ''
    127.0.0.1 storageos.storageos.svc storageos
  '';

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.eth1.ipv4.addresses = [{
    address = "10.0.0.2";
    prefixLength = 20;
  }];
  # networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  fileSystems."/mnt/readynas" = {
    device = "192.168.3.104:/media/wd/data";
    fsType = "nfs";
    options = [ "rw" "soft" "tcp" "nolock" "x-systemd.automount" "noauto"  ];
  };

  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user 
      smb encrypt = required
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 10.0.0.1 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      home = {
        path = "/home/mhmxs";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "mhmxs";
        "force group" = "users";
      };
    };
  };

  environment.variables = {
    LD_LIBRARY_PATH = "$(cat ${pkgs.gcc.outPath}/nix-support/cc-ldflags | cut -dL -f2 | sed 's/.$//'):/run/current-system/sw/lib:/run/current-system/kernel-modules/lib";
  };

  system.activationScripts.nonposix.text = ''
    ln -sf /run/current-system/sw/bin/bash /bin/bash
    rm -rf /lib64 ; mkdir /lib64 ; ln -sf ${pkgs.glibc.outPath}/lib/ld-linux-x86-64.so.2 /lib64
  '';

    nix = {
    # settings = {
    #   substituters = [
    #     "https://nix-community.cachix.org"
    #     "https://skm-nixos.cachix.org"
    #   ];
    #   trusted-public-keys = [
    #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #     "skm-nixos.cachix.org-1:/vQ9eIf7dL0imfHCWQGI1W/TVKceo6OYBsX0RvS55xs="
    #   ];

    #   trusted-users = [ "root" "@wheel" ];
    #   auto-optimise-store = true;
    # };
    # package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    # gc = {
    #   automatic = true;
    #   dates = "daily";
    # };
  };
}
