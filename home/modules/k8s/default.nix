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
  options.k8s = {
    enable = lib.mkEnableOption "k8s";

    helm = {
      enable = lib.mkEnableOption "helm";
    };
    k9s = {
      enable = lib.mkEnableOption "k9s";
    };
  };

  imports = [
    ./helm.nix
    ./k9s.nix
  ];

  config = lib.mkIf cfg.enable {
    k8s.helm.enable = lib.mkDefault true;
    k8s.k9s.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      argocd
      fluxcd
      k3d
      kubectl
      kustomize
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
