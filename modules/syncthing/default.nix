{ lib, config, ... }:

let
  cfg = config.syncthing;
  inherit (config.host) username;

  deviceRegistry = import ./devices.nix;
  deviceName = lib.types.enum (builtins.attrNames deviceRegistry);
  referencedDevices = lib.unique (
    lib.concatMap (folder: folder.devices) (lib.attrValues cfg.folders)
  );
in
{
  options.syncthing = {
    enable = lib.mkEnableOption "syncthing";
    folders = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            path = lib.mkOption {
              type = lib.types.str;
            };
            type = lib.mkOption {
              type = lib.types.enum [
                "sendreceive"
                "sendonly"
                "receiveonly"
                "receiveencrypted"
              ];
              default = "sendreceive";
            };
            devices = lib.mkOption {
              type = lib.types.listOf deviceName;
              default = [ ];
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${username} = { };
    users.users.${username}.extraGroups = [ username ];

    services.syncthing = {
      enable = true;
      user = username;
      group = username;
      configDir = "/home/${username}/.local/state/syncthing";
      openDefaultPorts = true;
      settings = {
        devices = lib.getAttrs referencedDevices deviceRegistry;
        folders = lib.mapAttrs (_: folder: {
          inherit (folder)
            path
            type
            devices
            ;
        }) cfg.folders;
        options = {
          globalAnnounceEnabled = false;
          localAnnounceEnabled = true;
          relaysEnabled = false;
        };
      };
    };
  };
}
