{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.infra;
in
{
  options.infra = {
    enable = lib.mkEnableOption "infrastructure tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      opentofu
      upbound
    ];
  };
}
