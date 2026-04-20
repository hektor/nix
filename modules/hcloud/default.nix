{
  lib,
  config,
  ...
}:

let
  cfg = config.hcloud;
  inherit (config.host) username;
  inherit (config.secrets) owner;
in
{
  options.hcloud = {
    enable = lib.mkEnableOption "hcloud CLI configuration";
  };

  config = lib.mkIf cfg.enable {
    secrets.groups.hcloud = [ "api-token" ];

    sops.templates."hcloud/cli.toml" = {
      inherit owner;
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
