{ lib, config, ... }:

let
  cfg = config.syncthing;
  inherit (config.host) username;
in
{
  options.syncthing.enable = lib.mkEnableOption "syncthing";

  config = lib.mkIf cfg.enable {
    users.groups.${username} = { };
    users.users.${username}.extraGroups = [ username ];

    services.syncthing = {
      enable = true;
      user = username;
      group = username;
      configDir = "/home/${username}/.local/state/syncthing";
      openDefaultPorts = true;
    };
  };
}
