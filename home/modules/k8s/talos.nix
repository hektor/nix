{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.k8s.talos.enable {
    home.packages = [ pkgs.talosctl ];
  };
}
