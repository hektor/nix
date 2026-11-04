{ lib, config, ... }:

{
  options.bootloader = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
    firmware = lib.mkOption {
      default = "uefi";
      type = lib.types.enum [
        "bios"
        "uefi"
      ];
    };
  };

  config = lib.mkIf config.bootloader.enable (
    lib.mkMerge [
      (lib.mkIf (config.bootloader.firmware == "uefi") {
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      })
      (lib.mkIf (config.bootloader.firmware == "bios") {
        boot.loader.grub.enable = true;
      })
    ]
  );
}
