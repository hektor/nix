{ pkgs, ... }:
{
  home.packages = with pkgs; [
    haskellPackages.pandoc-crossref
    pandoc
    texliveSmall
  ];
}
