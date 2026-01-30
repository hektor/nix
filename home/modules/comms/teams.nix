{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.comms.teams.enable {
    home.packages = with pkgs; [
      (if config.lib ? nixGL then config.lib.nixGL.wrap teams-for-linux else teams-for-linux)
    ];
  };
}
