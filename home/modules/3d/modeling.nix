{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.modules."3d".modeling.enable {
    home.packages = with pkgs; [
      blender
      openscad-lsp
      openscad-unstable
    ];
  };
}
