{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

{
  system.stateVersion = "25.05";

  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.default
    ./hard.nix
    ../../modules/bootloader.nix
    (import ../../modules/disko.zfs-encrypted-root.nix {
      device = "/dev/nvme1n1";
      inherit lib;
      inherit config;
    })
    ../../modules/gnome.nix
    ../../modules/bluetooth.nix
    ../../modules/keyboard
    (import ../../modules/networking.nix { hostName = "andromache"; })
    ../../modules/users.nix
    ../../modules/audio.nix
    ../../modules/printing.nix
    ../../modules/localization.nix
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
  ];

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

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  environment.systemPackages = [ inputs.nvim.packages.x86_64-linux.nvim ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.h = import ../../home/hosts/andromache {
      inherit inputs;
      inherit config;
      inherit pkgs;
    };
  };

  networking = {
    hostId = "80eef97e";
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
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
