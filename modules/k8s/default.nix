{ config, lib, ... }:

{
  imports = [
    ./crossplane.nix
    ./talos.nix
  ];

  options.k8s = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
    crossplane.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
    talos = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      platform = lib.mkOption {
        default = "qemu";
        type = lib.types.enum [
          "docker"
          "qemu"
        ];
      };
    };
  };

  config = lib.mkIf config.k8s.enable {
    k8s.talos.enable = lib.mkDefault true;
  };
}
