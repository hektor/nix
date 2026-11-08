{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  meta = import ./meta.nix;
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ../../modules
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib config;
      device = "/dev/nvme1n1";
    })
  ];

  inherit (meta) host;

  hardware = {
    facter.reportPath = ./facter.json;
    cpu.intel.updateMicrocode = true;
    hackrf.enable = true;
  };

  "ai-tools".enable = true;
  anki.enable = true;
  audio.enable = true;
  bluetooth.enable = true;
  bootloader.enable = true;
  desktop.niri.enable = true;
  gaming.enable = true;
  git.enable = true;
  graphics = {
    enable = true;
    intel = {
      enable = true;
      model = "uhd-770";
    };
  };
  keyboard.enable = true;
  localization.enable = true;
  lynis.enable = true;
  memory.zram.enable = true;
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
  k8s.enable = true;
  hardening.enable = true;
  hcloud.enable = true;
  networking = {
    enable = true;
    hostId = "80eef97e";
    useDHCP = lib.mkDefault true;
  };
  restic-backup = {
    enable = true;
    paths = [
      "/home"
      "/data"
    ];
  };
  sandboxing.enable = true;
  secrets = {
    enable = true;
    nix = [ "signing-key" ];
  };
  ssh.enable = true;
  storage.enable = true;
  readings = {
    enable = true;
    peers = [
      "astyanax"
      "boox"
    ];
  };
  tailscale.enable = true;
  taskwarrior.enable = true;
  wol.interfaces.eno1.macAddress = "02:68:b3:29:da:98";
  zfs.enable = true;

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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };
}
