{ lib, config, ... }:

{
  options.printing.enable = lib.mkEnableOption "printing";

  config = lib.mkIf config.printing.enable {
    services.printing.enable = true;
  };
}
