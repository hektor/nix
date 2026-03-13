{
  lib,
  config,
  ...
}:

let
  cfg = config.hcloud;
  inherit (config.secrets) sopsDir;
in
{
  options.hcloud = {
    enable = lib.mkEnableOption "hcloud CLI configuration";
    username = lib.mkOption {
      type = lib.types.str;
      description = "Username for hcloud CLI configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.hcloud-token = {
      sopsFile = "${sopsDir}/hcloud-token";
      owner = config.users.users.${cfg.username}.name;
    };

    sops.templates."hcloud/cli.toml" = {
      owner = config.users.users.${cfg.username}.name;
      path = "/home/${cfg.username}/.config/hcloud/cli.toml";
      content = ''
        active_context = "server"

        [[contexts]]
          name = "server"
          token = "${config.sops.placeholder.hcloud-token}"
      '';
    };
  };
}
