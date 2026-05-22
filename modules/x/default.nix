{ lib, config, ... }:

{
  options.desktop.x.enable = lib.mkEnableOption "xmonad desktop";

  config = lib.mkIf config.desktop.x.enable {
    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = builtins.readFile ../../dots/.xmonad/xmonad.hs;
    };

    services.xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
    };
  };
}
