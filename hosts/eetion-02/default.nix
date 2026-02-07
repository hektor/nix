{ pkgs, ... }:

# Raspberry Pi 3
# See <https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_3>

let
  username = "h";
  hostName = "eetion-02";
in
{
  imports = [
    ./hard.nix
    ../../modules/ssh/hardened-openssh.nix
  ];

  ssh = {
    inherit username;
    publicHostname = "eetion-02";
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
    inherit hostName;
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
    ${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services = {
    openssh = {
      enable = true;
      harden = true;
    };
  };

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
