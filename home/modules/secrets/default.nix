{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.secrets = {
    enable = lib.mkEnableOption "secrets";

    vault = {
      enable = lib.mkEnableOption "vault CLI";
    };
  };

  imports = [ ./vault.nix ];

  config = lib.mkIf config.secrets.enable {
    home.packages = with pkgs; [
      age
      age-plugin-yubikey
      sops
    ];
  };
}
