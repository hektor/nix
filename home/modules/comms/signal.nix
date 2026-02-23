{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.comms.signal.enable {
    home.packages = [ (config.nixgl.wrap (config.wrapApp pkgs.signal-desktop "--no-sandbox")) ];
  };
}
