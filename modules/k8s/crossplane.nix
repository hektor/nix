{ config, lib, ... }:

{
  options.k8s.crossplane.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.k8s.crossplane.enable {
    nixpkgs.allowedUnfree = [ "upbound" ];
  };
}
