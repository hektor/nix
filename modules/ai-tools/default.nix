{ config, ... }:

let
  inherit (config.host) username;
  inherit (config.secrets) owner;
in
{
  config = {
    nixpkgs.allowedUnfree = [ "claude-code" ];
    secrets.groups.opencode = [ "api-key" ];

    sops.templates."opencode/auth.json" = {
      inherit owner;
      path = "/home/${username}/.local/share/opencode/auth.json";
      content = ''
        {
          "zai-coding-plan": {
            "type": "api",
            "key": "${config.sops.placeholder."opencode/api-key"}"
          }
        }
      '';
    };
  };
}
