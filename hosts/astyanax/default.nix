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
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.default
    ./hard.nix
    ../../modules/bootloader.nix
    (import ../../modules/disko.zfs-encrypted-root.nix {
      inherit lib;
      inherit config;
      device = "/dev/nvme0n1";
    })
    ../../modules/gnome.nix
    ../../modules/bluetooth.nix
    ../../modules/keyboard
    (import ../../modules/networking.nix { hostName = "astyanax"; })
    ../../modules/users.nix
    ../../modules/audio.nix
    ../../modules/localization.nix
    ../../modules/fonts
    ../../modules/ssh/hardened-openssh.nix
  ];

  sops = {
    validateSopsFiles = false;
    defaultSopsFile = "${builtins.toString inputs.nix-secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/h/.config/sops/age/keys.txt";

    secrets = {
      "test" = { };

      "taskwarrior_sync_server_url".owner = config.users.users.h.name;
      "taskwarrior_sync_server_client_id".owner = config.users.users.h.name;
      "taskwarrior_sync_encryption_secret".owner = config.users.users.h.name;
    };

    templates."taskrc.d/sync" = {
      owner = config.users.users.h.name;
      content = ''
        sync.server.url=${config.sops.placeholder."taskwarrior_sync_server_url"}
        sync.server.client_id=${config.sops.placeholder."taskwarrior_sync_server_client_id"}
        sync.encryption_secret=${config.sops.placeholder."taskwarrior_sync_encryption_secret"}
      '';
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
    users.h = import ../../home/hosts/astyanax {
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
