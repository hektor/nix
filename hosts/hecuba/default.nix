{ pkgs, ... }:

# Also see <https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud>

{
  imports = [
    ./hard.nix
    ../../modules/common.nix
    ../../modules/ssh/hardened-openssh.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
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
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOOXPEhdKOVnb6mkeLLUcFGt+mnUR5pMie17JtjrxwgO h@andromache"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    harden = true;
  };
}
