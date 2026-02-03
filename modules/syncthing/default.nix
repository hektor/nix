{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.my.syncthing;
  allDevices = import ./devices.nix;
in
{
  options.my.syncthing = {
    enable = mkEnableOption "Syncthing file synchronization";
    username = mkOption {
      type = types.str;
      default = "h";
    };
    deviceNames = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    folders = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            path = mkOption { type = types.path; };
            id = mkOption { type = types.str; };
            devices = mkOption {
              type = types.listOf (
                types.either types.str (
                  types.submodule {
                    options = {
                      device = mkOption { type = types.str; };
                      type = mkOption {
                        type = types.str;
                        default = "sendreceive";
                      };
                    };
                  }
                )
              );
              default = cfg.deviceNames;
            };
          };
        }
      );
      default = { };
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.username} = { };

    services.syncthing = {
      enable = true;
      user = cfg.username;
      group = cfg.username;
      configDir = "/home/${cfg.username}/.local/state/syncthing";
      openDefaultPorts = true;
      settings = {
        options = {
          localAnnounceEnabled = true;
          globalAnnounceEnabled = true;
          relaysEnabled = true;
          urAccepted = -1;
        };
        devices = mapAttrs (name: id: { inherit id; }) (
          filterAttrs (name: _: elem name cfg.deviceNames) allDevices
        );
        folders = mapAttrs (name: folder: {
          inherit (folder) id path;
          devices = map (
            device:
            if isString device then
              allDevices.${device}
            else
              device // { deviceID = allDevices.${device.device}; }
          ) folder.devices;
        }) cfg.folders;
      };
    };
  };
}
