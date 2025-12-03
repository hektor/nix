{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  username = "h";
in
{
  imports = [
    ../../modules/common.nix
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
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
    ../../modules/localization.nix
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
    (import ../../modules/secrets {
      inherit lib;
      inherit inputs;
      inherit config;
    })
    ../../modules/docker.nix
  ];

  secrets.username = username;
  docker.user = username;

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
    cpu.intel.updateMicrocode = true;
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../home/hosts/andromache {
      inherit lib;
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
      "/home/${username}/sync" = {
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

  networking = {
    interfaces = {
      eno1 = {
        wakeOnLan.enable = true;
      };
    };
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };
}
