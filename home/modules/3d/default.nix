{ lib, ... }:

{
  options.modules."3d" = {
    printing = {
      enable = lib.mkEnableOption "3D printing tools";
    };
    modeling = {
      enable = lib.mkEnableOption "3D modeling tools";
    };
  };

  imports = [
    ./printing.nix
    ./modeling.nix
  ];
}
