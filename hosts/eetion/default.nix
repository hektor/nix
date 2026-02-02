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
  ssh.publicHostname = "eetion";
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

  environment.etc."paperless-admin-pass".text = "admin";

  services.paperless = {
    enable = true;
    passwordFile = "/etc/paperless-admin-pass";
    settings = {
      PAPERLESS_URL = "http://paperless.eetion";
    };
  };

  # added (OPNSense) domain override to make this work on LAN
  #
  # host: eetion
  # domain: <domain (e.g. lan)>
  # ip address: <eetion-ip>
  #
  # host: paperless
  # domain: eetion
  # ip address: <eetion-ip>
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "eetion" = {
        default = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5006";
        };
      };
      "paperless.eetion" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:28981";
        };
      };
    };
  };

  virtualisation = {
    podman.enable = true;
    oci-containers = {
      backend = "podman";
      containers.actualbudget = {
        image = "docker.io/actualbudget/actual-server:latest-alpine";
        ports = [ "5006:5006" ];
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
