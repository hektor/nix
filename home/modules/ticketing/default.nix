{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.ticketing;
in
{
  options.ticketing = {
    enable = lib.mkEnableOption "ticketing";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      jira-cli-go
    ];
  };
}
