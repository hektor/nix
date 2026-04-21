{ config, myUtils, ... }:

let
  inherit (config.secrets) sopsDir;
  inherit (config.host) username;
  owner = config.users.users.${username}.name;
in
{
  config.sops = {
    secrets = myUtils.mkSopsSecrets sopsDir "opencode" [ "api-key" ] { inherit owner; };

    templates."opencode/auth.json" = {
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
