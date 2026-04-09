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
    ../../modules/common
    ../../modules/boot/bootloader.nix
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib config;
      device = "/dev/nvme1n1";
    })
    ../../modules/audio
    ../../modules/backups
    ../../modules/bluetooth
    ../../modules/desktops/niri
    ../../modules/docker
    ../../modules/firewall
    ../../modules/fonts
    ../../modules/gaming
    ../../modules/hcloud
    ../../modules/keyboard
    ../../modules/localization
    ../../modules/networking
    ../../modules/nvidia
    (import ../../modules/secrets { inherit lib inputs config; })
    ../../modules/ssh
    ../../modules/storage
    ../../modules/stylix
    ../../modules/syncthing
    ../../modules/tailscale
    ../../modules/users
    ../../modules/wol
    ../../modules/yubikey
  ];

  home-manager.users.${config.host.username} = import ../../home/hosts/andromache {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };

  ssh.username = config.host.username;
  ssh.authorizedHosts = [ "astyanax" ];

  secrets = {
    inherit (config.host) username;
    nixSigningKey.enable = true;
  };

  tailscale.enable = true;

  docker.user = config.host.username;

  hcloud = {
    enable = true;
    inherit (config.host) username;
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

  my.yubikey = {
    enable = false;
    inherit (config.host) username;
    keys = [
      {
        handle = "<KeyHandle1>";
        userKey = "<UserKey1>";
        coseType = "<CoseType1>";
        options = "<Options1>";
      }
      {
        handle = "<KeyHandle2>";
        userKey = "<UserKey2>";
        coseType = "<CoseType2>";
        options = "<Options2>";
      }
    ];
  };

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  networking.hostId = "80eef97e";

  wol = {
    enable = true;
    interfaces.eno1 = { inherit (wolInterfaces.eno1) macAddress; };
  };

  firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
}
