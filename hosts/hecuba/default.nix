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
    inputs.arion.nixosModules.arion
    "${inputs.hecuba-services}"
    ../../modules
  ];

  inherit (meta) host;

  hardware.facter.reportPath = ./facter.json;

  docker.enable = true;
  secrets.enable = true;
  ssh.enable = true;
  tailscale.enable = true;

  secrets.hecuba-gitea-runner = [ "registration_token" ];

  sops.templates."gitea-runner.env".content = ''
    TOKEN=${config.sops.placeholder."hecuba-gitea-runner/registration_token"}
  '';

  services.gitea-actions-runner.instances.hecuba = {
    enable = true;
    name = "hecuba";
    url = "https://git.hektormisplon.xyz";
    tokenFile = config.sops.templates."gitea-runner.env".path;
    labels = [ "nix:host" ];
    hostPackages = with pkgs; [
      bash
      coreutils
      git
      nix
      nodejs
      openssh
    ];
  };

  virtualisation.arion.backend = "docker";

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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
  };

  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
    flags = [ "--all" ];
  };

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
    fail2ban = {
      enable = true;
      maxretry = 5;
    };
    journald.extraConfig = "SystemMaxUse=500M";
  };
}
