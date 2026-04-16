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

  home.shellAliases = {
    k = "kubectl";
  };

  imports = [
    ./helm.nix
    ./k9s.nix
  ];
}
