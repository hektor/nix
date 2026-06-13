{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.ssh;
in
{
  options.ssh.enable = lib.mkEnableOption "ssh";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ sshfs ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          AddKeysToAgent = "yes";
          ForwardAgent = false;
          identityFile = [
            "~/.ssh/id_ed25519_sk"
            "~/.ssh/id_ed25519_sk_bak"
          ];
        };
      };
    };
  };
}
