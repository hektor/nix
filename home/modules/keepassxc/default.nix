{
  config,
  lib,
  ...
}:

let
  cfg = config.keepassxc;
in
{
  options.keepassxc.enable = lib.mkEnableOption "KeePassXC";

  config = lib.mkIf cfg.enable {
    programs.keepassxc = {
      enable = true;
      settings = {
        Browser.Enabled = true;
      };
    };
  };
}
