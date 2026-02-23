{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.comms.teams.enable {
    home.packages = [ (config.nixgl.wrap (config.wrapApp pkgs.teams-for-linux "--no-sandbox")) ];
  };
}
