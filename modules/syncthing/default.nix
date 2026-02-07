{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.my.syncthing;
in
{
  options.my.syncthing = {
    enable = mkEnableOption "Syncthing file synchronization";
    username = mkOption {
      type = types.str;
      default = "h";
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.username} = { };
    users.users.${cfg.username}.extraGroups = [ cfg.username ];

    services.syncthing = {
      enable = true;
      user = cfg.username;
      group = cfg.username;
      configDir = "/home/${cfg.username}/.local/state/syncthing";
      openDefaultPorts = true;
    };
  };
}
