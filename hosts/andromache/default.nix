{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  username = "h";
  wolInterfaces = import ./wol-interfaces.nix;
in
{
  imports = [
    ../../modules/common
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.default
    ./hard.nix
    ../../modules/boot/bootloader.nix
    (import ../../modules/disko/zfs-encrypted-root.nix {
      device = "/dev/nvme1n1";
      inherit lib;
      inherit config;
    })
    ../../modules/desktops/niri
    ../../modules/bluetooth
    ../../modules/keyboard
    (import ../../modules/networking { hostName = "andromache"; })
    ../../modules/users
    ../../modules/audio
    ../../modules/localization
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
    (import ../../modules/secrets {
      inherit lib;
      inherit inputs;
      inherit config;
    })
    ../../modules/docker
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
    settings = {
      devices = {
        # "device1" = {
        #   id = "DEVICE-ID-GOES-HERE";
        # };
      };
      folders = {
        "/home/${username}/sync" = {
          id = "sync";
          devices = [ ];
        };
      };
    };
  };

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  networking = {
    # TODO: generate unique hostId on actual host with: head -c 8 /etc/machine-id
    hostId = "80eef97e";
    interfaces = {
      eno1 = {
        wakeOnLan.enable = true;
        macAddress = wolInterfaces.eno1.macAddress;
      };
    };
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };
}
