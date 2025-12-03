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
    ../../modules/common.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.default
    ./hard.nix
    ../../modules/bootloader.nix
    (import ../../modules/disko/zfs-encrypted-root.nix {
      inherit lib;
      inherit config;
      device = "/dev/nvme0n1";
    })
    ../../modules/desktops/niri
    ../../modules/bluetooth.nix
    ../../modules/keyboard
    (import ../../modules/networking.nix { hostName = hostName; })
    ../../modules/users.nix
    ../../modules/audio.nix
    ../../modules/localization.nix
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
    (import ../../modules/secrets {
      inherit lib;
      inherit inputs;
      inherit config;
      inherit username;
    })
  ];

  secrets.username = username;

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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../home/hosts/astyanax {
      inherit inputs;
      inherit config;
      inherit pkgs;
    };
  };

  networking = {
    hostId = "80eef97e";
  };

  services.openssh = {
    enable = true;
    harden = true;
  };

  services.syncthing = {
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

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };
}
