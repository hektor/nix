{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  wolInterfaces = import ./wol-interfaces.nix;
in
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hard.nix
    ./host.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ../../modules
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib config;
      device = "/dev/nvme1n1";
    })
  ];

  home-manager.users.${config.host.username} = import ../../home/hosts/${config.host.name};

  "ai-tools".enable = true;
  anki.enable = true;
  audio.enable = true;
  bluetooth.enable = true;
  bootloader.enable = true;
  desktop.niri.enable = true;
  firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
  gaming.enable = true;
  git.enable = true;
  keyboard.enable = true;
  localization.enable = true;
  my = {
    fonts.enable = true;
    stylix.enable = true;
    users.enable = true;
    yubikey = {
      enable = true;
      pam.enable = false;
    };
  };
  desktop.ly.enable = true;
  docker.enable = true;
  hcloud.enable = true;
  networking.enable = true;
  nvidia.enable = true;
  restic-backup.enable = true;
  secrets = {
    enable = true;
    nixSigningKey.enable = true;
  };
  ssh.enable = true;
  storage.enable = true;
  syncthing.enable = true;
  tailscale.enable = true;
  taskwarrior.enable = true;
  wol = {
    enable = true;
    interfaces.eno1 = { inherit (wolInterfaces.eno1) macAddress; };
  };

  disko.devices = {
    disk.data = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          data = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/data";
            };
          };
        };
      };
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = [
    inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena
  ];

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  networking.hostId = "80eef97e";
}
