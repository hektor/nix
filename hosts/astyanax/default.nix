{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  username = "h";
  hostName = "astyanax";
  wolInterfaces = import ../andromache/wol-interfaces.nix;
in
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../modules/common
    ./hard.nix
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel-gen7 (not available yet?)
    inputs.sops-nix.nixosModules.sops
    ../../modules/boot/bootloader.nix
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib config;
      device = "/dev/nvme0n1";
    })
    ../../modules/desktops/niri
    ../../modules/audio
    ../../modules/audio-automation
    ../../modules/backups
    ../../modules/bluetooth
    ../../modules/keyboard
    (import ../../modules/networking { inherit hostName; })
    ../../modules/users
    ../../modules/localization
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
    ../../modules/stylix
    # ../../modules/vpn/wireguard.nix
    (import ../../modules/secrets { inherit lib inputs config; })
    ../../modules/docker
    ../../modules/syncthing
    ../../modules/nfc
  ];

  home-manager.users.${username} = import ../../home/hosts/astyanax {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };

  networking.hostName = hostName;

  ssh.username = username;
  ssh.authorizedHosts = [ "andromache" ];

  secrets.username = username;
  docker.user = username;
  nfc.user = username;

  nix.settings.secret-key-files = [ config.sops.secrets.nix_signing_key_astyanax.path ];

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
    inputs.colmena.packages.${pkgs.system}.colmena
    (pkgs.writeShellApplication {
      name = "wol-andromache";
      runtimeInputs = [ pkgs.wakeonlan ];
      text = ''
        wakeonlan ${wolInterfaces.eno1.macAddress}
      '';
    })
  ];

  networking = {
    # TODO: generate unique hostId on actual host with: head -c 8 /etc/machine-id
    hostId = "80eef97e";
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services = {
    fwupd.enable = true;
    openssh = {
      enable = true;
      harden = true;
    };
    locate = {
      enable = true;
      package = pkgs.plocate;
    };
  };

  my.syncthing.enable = true;
}
