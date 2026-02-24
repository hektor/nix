{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.secrets = {
    enable = lib.mkEnableOption "secrets";
  };

  imports = [ ./vault.nix ];

  config = lib.mkIf config.secrets.enable {
    home.packages = with pkgs; [
      sops
      age
    ];
  };
}
