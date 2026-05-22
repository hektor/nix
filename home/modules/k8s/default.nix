{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.k8s;
in
{
  imports = [
    ./helm.nix
    ./k9s.nix
  ];

  options.k8s.enable = lib.mkEnableOption "k8s";

  config = lib.mkIf cfg.enable {
    k8s.helm.enable = lib.mkDefault true;
    k8s.k9s.enable = lib.mkDefault true;

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
  };
}
