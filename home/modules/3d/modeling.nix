{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    home.packages =
      with pkgs;
      lib.optionals config.modules."3d".modeling.blender.enable [
        blender
      ]
      ++ lib.optionals config.modules."3d".modeling.openscad.enable [
        openscad-lsp
        openscad-unstable
      ];
  };
}
