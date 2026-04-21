{
  lib,
  config,
  ...
}:

with lib;

let
  inherit (config.host) username;
in
{
  config = {
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
