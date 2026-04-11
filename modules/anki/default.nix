{ config, myUtils, ... }:

let
  inherit (config.secrets) sopsDir username;
  owner = config.users.users.${username}.name;
in
{
  config.sops = {
    secrets = myUtils.mkSopsSecrets sopsDir "anki" [ "sync-user" "sync-key" ] { inherit owner; };
  };
}
