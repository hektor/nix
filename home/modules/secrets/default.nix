{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./vault.nix ];

  options.secrets.enable = lib.mkEnableOption "secrets";

  config = lib.mkIf config.secrets.enable {
    home.packages = with pkgs; [
      age
      age-plugin-yubikey
      sops
    ];
  };
}
