{ lib, config, ... }:

{
  options.storage.enable = lib.mkEnableOption "storage";

  config = lib.mkIf config.storage.enable {
    services.udisks2.enable = true;
    boot.zfs.forceImportRoot = false;
  };
}
