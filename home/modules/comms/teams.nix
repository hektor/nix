{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.comms.teams.enable {
    home.packages = [ (config.nixgl.wrap pkgs.teams-for-linux) ];
  };
}
