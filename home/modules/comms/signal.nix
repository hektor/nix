{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.comms.signal.enable {
    home.packages = [ (config.nixgl.wrap pkgs.signal-desktop) ];
  };
}
