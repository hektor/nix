{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bambu-studio
    blender
    openscad-lsp
    openscad-unstable
    orca-slicer
  ];
}
