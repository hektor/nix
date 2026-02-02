{ pkgs, ... }:

# Orange Pi Zero2 H616
# See <https://nixos.wiki/wiki/NixOS_on_ARM/Orange_Pi_Zero2_H616>

let
  username = "h";
  hostName = "eetion";
in
{
  imports = [
    ./hard.nix
    ../../modules/ssh/hardened-openssh.nix
  ];

  ssh.username = username;
  ssh.authorizedHosts = [
    "andromache"
    "astyanax"
  ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };

  users.users = {
    root.hashedPassword = "!";
    ${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    harden = true;
  };

  virtualisation = {
    podman.enable = true;
    oci-containers = {
      backend = "podman";
      containers.actualbudget = {
        image = "docker.io/actualbudget/actual-server:latest-alpine";
        ports = [ "80:5006" ];
        volumes = [ "/var/lib/actualbudget:/data" ];
      };
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
