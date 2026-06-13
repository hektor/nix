{
  inputs,
  pkgs,
  config,
  ...
}:

# also see <https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud>

let
  meta = import ./meta.nix;
in
{
  imports = [
    inputs.disko.nixosModules.disko
    "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    inputs.comin.nixosModules.comin
    ../../modules
  ];

  inherit (meta) host;

  hardware.facter.reportPath = ./facter.json;

  docker.enable = true;
  ssh.enable = true;
  tailscale.enable = true;

  networking.hostName = config.host.name;

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
    ${config.host.username} = {
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
    kitty.terminfo
  ];

  services = {
    comin = {
      enable = false;
      machineId = "4c0a7f7726a845859ce9375e88b87642";
      remotes = [
        {
          name = "origin";
          url = "https://git.hektormisplon.xyz/hektor/nix";
          branches.main.name = "main";
        }
      ];
    };
    fail2ban = {
      enable = true;
      maxretry = 5;
    };
  };
}
