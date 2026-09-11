{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.secrets.vault.enable {
    home.packages = with pkgs; [ vault-bin ];
  };
}
