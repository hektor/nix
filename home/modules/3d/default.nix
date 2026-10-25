{ lib, ... }:

{
  options.modules."3d" = {
    printing = {
      enable = lib.mkEnableOption "3D printing tools";
    };
    modeling = {
      blender = {
        enable = lib.mkOption {
          default = false;
          type = lib.types.bool;
        };
      };
      openscad = {
        enable = lib.mkOption {
          default = false;
          type = lib.types.bool;
        };
      };
    };
  };

  imports = [
    ./printing.nix
    ./modeling.nix
  ];
}
