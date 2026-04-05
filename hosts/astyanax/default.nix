{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  wolInterfaces = import ../andromache/wol-interfaces.nix;
in
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hard.nix
    ./host.nix
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel-gen7 (not available yet?)
    ../../modules/common
    ../../modules/boot/bootloader.nix
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib config;
      device = "/dev/nvme0n1";
    })
    ../../modules/desktops/niri
    ../../modules/audio
    ../../modules/backups
    ../../modules/bluetooth
    ../../modules/keyboard
    ../../modules/networking
    ../../modules/users
    ../../modules/localization
    ../../modules/fonts
    ../../modules/ssh
    ../../modules/storage
    ../../modules/stylix
    (import ../../modules/secrets { inherit lib inputs config; })
    ../../modules/docker
    ../../modules/nfc
    ../../modules/firewall
  ];

  home-manager.users.${config.host.username} = import ../../home/hosts/astyanax {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };

  ssh.username = config.host.username;
  ssh.authorizedHosts = [ "andromache" ];

  secrets = {
    inherit (config.host) username;
    nixSigningKey.enable = true;
  };
  docker.user = config.host.username;
  nfc.user = config.host.username;
  desktop.ly.enable = true;
  audio.automation.enable = true;

  hardware = {
    cpu.intel.updateMicrocode = true;
    # https://wiki.nixos.org/wiki/Intel_Graphics
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };

  # https://wiki.nixos.org/wiki/Intel_Graphics
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  environment.systemPackages = [
    inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena
    (pkgs.writeShellApplication {
      name = "wol-andromache";
      runtimeInputs = [ pkgs.wakeonlan ];
      text = ''
        wakeonlan ${wolInterfaces.eno1.macAddress}
      '';
    })
  ];

  networking = {
    hostId = "80eef97e";
  };

  firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services = {
    fwupd.enable = true;
    locate = {
      enable = true;
      package = pkgs.plocate;
    };
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
      };
    };
  };
}
