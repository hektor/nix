{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.k8s.helm;
in
{
  options.k8s.helm.enable = lib.mkEnableOption "helm";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (wrapHelm kubernetes-helm {
        plugins = with kubernetes-helmPlugins; [
          helm-diff
          helm-git
          helm-schema
          helm-secrets
          helm-unittest
        ];
      })
    ];
  };
}
