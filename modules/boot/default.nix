{ lib, config, ... }:

let
  cfg = config.bootloader;
in
{
  options.bootloader.enable = lib.mkEnableOption "system bootloader";

  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      tmp.useTmpfs = config.host.highRam;
    };
  };
}
