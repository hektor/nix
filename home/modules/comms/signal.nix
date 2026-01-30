{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.comms.signal.enable {
    home.packages = with pkgs; [
      (if config.lib ? nixGL then config.lib.nixGL.wrap signal-desktop else signal-desktop)
    ];
  };
}
