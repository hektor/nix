{ lib, config, ... }:

let
  cfg = config.git;
  inherit (config.host) username;
  owner = config.users.users.${username}.name;
in
{
  options.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    sops.templates = {
      ".gitconfig.email" = {
        inherit owner;
        path = "/home/${username}/.gitconfig.email";
        content = ''
          [user]
            email = ${config.sops.placeholder."email/personal"}
        '';
      };
      ".gitconfig.work.email" = {
        inherit owner;
        path = "/home/${username}/.gitconfig.work.email";
        content = ''
          [user]
            email = ${config.sops.placeholder."email/work"}
        '';
      };
    };
  };
}
