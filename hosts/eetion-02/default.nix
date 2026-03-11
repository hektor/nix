{ pkgs, config, ... }:

# Raspberry Pi 3
# See <https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_3>

{
  imports = [
    ./hard.nix
    ../../modules/ssh
    ../../modules/common
  ];

  host = {
    username = "h";
    name = "eetion-02";
  };

  ssh = {
    inherit (config.host) username;
    publicHostname = config.host.name;
    authorizedHosts = [
      "andromache"
      "astyanax"
    ];
  };

  boot = {
    kernelParams = [
      "console=ttyS1,115200n8"
    ];

    kernel.sysctl."net.ipv4.ip_forward" = 1;

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = config.host.name;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
    };
  };

  users.users = {
    root.hashedPassword = "!";
    ${config.host.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  system.stateVersion = "26.05";
}
