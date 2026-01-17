{
  lib,
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:

# Also see <https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud>

{
  imports = [
    ./hard.nix
    ../../modules/common
    ../../modules/ssh/hardened-openssh.nix
  ];

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

  ssh = {
    username = "username";
    authorizedHosts = [ "andromache" ];
  };

  security.sudo.wheelNeedsPassword = false;

  networking = {
    firewall.enable = true;
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

  networking.hostName = "hecuba";
}
