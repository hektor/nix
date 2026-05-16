{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.my.yubikey = {
    enable = lib.mkEnableOption "yubikey";
  };

  config = lib.mkIf config.my.yubikey.enable {
    home.packages = with pkgs; [
      yubikey-manager
      yubikey-personalization
    ];
  };
}
