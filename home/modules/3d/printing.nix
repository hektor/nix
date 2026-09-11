{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.modules."3d".printing.enable {
    home.packages = with pkgs; [ orca-slicer ];
  };
}
