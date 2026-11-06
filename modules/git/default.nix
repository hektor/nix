{ lib, config, ... }:

let
  cfg = config.git;
  inherit (config.host) username;
  owner = config.users.users.${username}.name;
in
{
  options.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    sops.templates = lib.genAttrs' [ "personal" "work" ] (
      key:
      lib.nameValuePair ".gitconfig.${key}.email" {
        inherit owner;
        content = ''
          [user]
            email = ${config.sops.placeholder."email/${key}"}
        '';
      }
    );
  };
}
