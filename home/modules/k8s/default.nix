{ pkgs, ... }:

{
  home.packages = with pkgs; [
    argocd
    fluxcd
    k3d
    kubectl
    kubernetes
    kubernetes-helm
    kustomize
    minikube
    opentofu
    upbound
  ];

  imports = [ ./k9s.nix ];
}
