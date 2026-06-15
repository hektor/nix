{ config, lib, ... }:

let
  cfg = config.zathura;
in
{
  options.zathura.enable = lib.mkEnableOption "zathura";

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      extraConfig = builtins.readFile ./zathurarc;
    };
  };
}
