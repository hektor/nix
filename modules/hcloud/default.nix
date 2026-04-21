{
  lib,
  config,
  myUtils,
  ...
}:

let
  cfg = config.hcloud;
  inherit (config.host) username;
  inherit (config.secrets) sopsDir;
in
{
  options.hcloud = {
    enable = lib.mkEnableOption "hcloud CLI configuration";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = myUtils.mkSopsSecrets sopsDir "hcloud" [ "api-token" ] {
      owner = config.users.users.${username}.name;
    };

    sops.templates."hcloud/cli.toml" = {
      owner = config.users.users.${username}.name;
      path = "/home/${username}/.config/hcloud/cli.toml";
      content = ''
        active_context = "server"

        [[contexts]]
          name = "server"
          token = "${config.sops.placeholder."hcloud/api-token"}"
      '';
    };
  };
}
