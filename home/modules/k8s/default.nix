{ pkgs, ... }:

{
  home.packages = with pkgs; [
    argocd
    fluxcd
    k3d
    kubectl
    kubernetes
    kustomize
    minikube
    opentofu
    upbound
  ];

  imports = [
    ./helm.nix
    ./k9s.nix
  ];
}
