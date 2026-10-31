{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.k8s.crossplane.enable {
    home.packages = [ pkgs.upbound ];
  };
}
