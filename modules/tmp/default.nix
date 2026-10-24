{ lib, config, ... }:

{
  options.tmp.enable = lib.mkOption {
    default = config.host.highRam;
    type = lib.types.bool;
  };

  config = lib.mkIf config.tmp.enable {
    boot.tmp = {
      useTmpfs = true;
      tmpfsSize = "25%";
    };
  };
}
