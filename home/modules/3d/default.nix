{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules."3d";
in
{
  options.modules."3d" = {
    printing.enable = lib.mkEnableOption "3D printing tools";
    modeling.enable = lib.mkEnableOption "3D modeling tools";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.printing.enable {
      home.packages = with pkgs; [
        bambu-studio
        orca-slicer
      ];
    })
    (lib.mkIf cfg.modeling.enable {
      home.packages = with pkgs; [
        blender
        openscad-lsp
        openscad-unstable
      ];
    })
  ];
}
