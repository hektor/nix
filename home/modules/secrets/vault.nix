{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.secrets.vault = {
    enable = lib.mkEnableOption "vault CLI";
  };

  config = lib.mkIf config.secrets.vault.enable {
    home.packages = with pkgs; [ vault-bin ];
  };
}
