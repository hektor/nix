{
  inputs,
  pkgs,
  ...
}:

# Also see <https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud>

let
  username = "username";
  hostName = "hecuba";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../modules/common
    ./hard.nix
    ../../modules/ssh/hardened-openssh.nix
    ../../modules/docker
    ../../modules/uptime-kuma
  ];

  networking.hostName = hostName;
  ssh = {
    inherit username;
    publicHostname = "server.hektormisplon.xyz";
    authorizedHosts = [
      "andromache"
      "astyanax"
    ];
  };

  docker.user = username;

  my.uptime-kuma.enable = false;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };
  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  users.users = {
    root.hashedPassword = "!";
    username = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.fail2ban = {
    enable = true;
    maxretry = 5;
  };

  services.openssh = {
    enable = true;
    harden = true;
  };

  nix.settings = {
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "astyanax:JY2qJkZUFSax47R3c1nq53AZ8GnLfNqz6mSnJ60cLZ4="
      "andromache:XM4VLrEw63RB/3v/56OxzH/Yw+kKXKMBLKCb7UGAXzo="
    ];
    auto-optimise-store = true;
    keep-derivations = false;
    keep-outputs = false;
  };
}
