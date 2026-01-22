{
  lib,
  inputs,
  outputs,
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
    ../../modules/common
    ./hard.nix
    # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
    inputs.sops-nix.nixosModules.sops
    ../../modules/boot/bootloader.nix
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib config;
      device = "/dev/nvme0n1";
    })
    ../../modules/desktops/niri
    ../../modules/bluetooth
    ../../modules/keyboard
    (import ../../modules/networking { hostName = hostName; })
    ../../modules/users
    ../../modules/audio
    ../../modules/localization
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
    ../../modules/vpn/wireguard.nix
    (import ../../modules/secrets { inherit lib inputs config; })
    ../../modules/docker
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
    inputs.nvim.packages.x86_64-linux.nvim
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

  services = {
    fwupd.enable = true;
    openssh = {
      enable = true;
      harden = true;
    };
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      folders = {
        "/home/h/sync" = {
          id = "sync";
          devices = [ ];
        };
      };
      devices = {
        # "device1" = {
        #   id = "DEVICE-ID-GOES-HERE";
        # };
      };
    };
    locate = {
      enable = true;
      package = pkgs.plocate;
    };
  };
}
