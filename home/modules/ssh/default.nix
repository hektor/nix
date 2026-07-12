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

    services.ssh-agent.enable = true;

    systemd.user.services.ssh-agent.Service.Environment = [
      "SSH_ASKPASS=${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass"
      "SSH_ASKPASS_REQUIRE=prefer"
    ];

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
