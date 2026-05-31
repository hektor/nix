{
  inputs,
  pkgs,
  config,
  ...
}:

# Also see <https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud>

{
  imports = [
    inputs.disko.nixosModules.disko
    ./hard.nix
    inputs.comin.nixosModules.comin
    ./host.nix
    ../../modules
  ];

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
      enable = true;
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
