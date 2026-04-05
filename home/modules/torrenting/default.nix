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
    enable = lib.mkEnableOption "transmission torrent client";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      transmission_4
    ];
  };
}
