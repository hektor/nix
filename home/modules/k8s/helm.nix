{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.k8s.helm.enable {
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
