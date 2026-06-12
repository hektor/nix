{ config, lib, ... }:

{
  config = lib.mkIf config.k8s.crossplane.enable {
    nixpkgs.allowedUnfree = [ "upbound" ];
  };
}
