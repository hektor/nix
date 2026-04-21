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
    inputs.sops-nix.nixosModules.sops
    ../../modules/common
    ../../modules/boot/bootloader.nix
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib config;
      device = "/dev/nvme0n1";
    })
    ../../modules/ai-tools
    ../../modules/anki
    ../../modules/audio
    ../../modules/backups
    ../../modules/bluetooth
    ../../modules/desktops/niri
    ../../modules/docker
    ../../modules/firewall
    ../../modules/fonts
    ../../modules/git
    ../../modules/keyboard
    ../../modules/localization
    ../../modules/networking
    ../../modules/nfc
    ../../modules/secrets
    ../../modules/ssh
    ../../modules/storage
    ../../modules/stylix
    ../../modules/tailscale
    ../../modules/taskwarrior
    ../../modules/users
    ../../modules/yubikey
  ];

  home-manager.users.${config.host.username} = import ../../home/hosts/astyanax;

  ssh.authorizedHosts = [ "andromache" ];

  secrets.nixSigningKey.enable = true;

  tailscale.enable = true;
  docker.enable = true;
  nfc.enable = true;
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

  my.yubikey = {
    enable = true;
    # inherit (config.host) username;
    # keys = [
    #   {
    #     handle = "<KeyHandle1>";
    #     userKey = "<UserKey1>";
    #     coseType = "<CoseType1>";
    #     options = "<Options1>";
    #   }
    #   {
    #     handle = "<KeyHandle2>";
    #     userKey = "<UserKey2>";
    #     coseType = "<CoseType2>";
    #     options = "<Options2>";
    #   }
    # ];
  };

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
