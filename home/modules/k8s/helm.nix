{ pkgs, ... }:

{
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
}
