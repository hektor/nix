{ config, lib, ... }:

let
  inherit (config.host) username;
  home = config.users.users.${username}.home;
  devices = builtins.attrNames (import ../syncthing/devices.nix);
in
{
  options.readings = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
    path = lib.mkOption {
      default = "${home}/doc/readings";
      type = lib.types.str;
    };
    peers = lib.mkOption {
      type = lib.types.nonEmptyListOf (lib.types.enum devices);
    };
  };

  config = lib.mkIf config.readings.enable {
    assertions = [
      {
        assertion = !builtins.elem config.host.name config.readings.peers;
        message = "'readings.peers' for ${config.host.name} should not include '${config.host.name}'.";
      }
    ];

    syncthing = {
      enable = true;
      folders.readings = {
        inherit (config.readings) path;
        devices = config.readings.peers;
      };
    };

    home-manager.sharedModules = [
      {
        readings.path = lib.mkDefault config.readings.path;
      }
    ];
  };
}
