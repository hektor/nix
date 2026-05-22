{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.torrenting;
in
{
  options.torrenting = {
    enable = lib.mkEnableOption "torrenting";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      transmission_4
    ];
  };
}
