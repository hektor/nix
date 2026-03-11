{ pkgs, ... }:
{
  home.packages = [
    (pkgs.proxmark3.override { withGeneric = true; })
  ];
}
