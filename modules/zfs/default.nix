{ lib, config, ... }:

{
  options.zfs.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.zfs.enable {
    boot = {
      kernelParams = [ "zfs.zfs_arc_max=12884901888" ];
      zfs.forceImportRoot = lib.mkDefault false;
    };
  };
}
