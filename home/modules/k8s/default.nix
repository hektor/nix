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

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };

  imports = [
    ./helm.nix
    ./k9s.nix
  ];
}
