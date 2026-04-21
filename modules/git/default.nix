{
  config,
  ...
}:

let
  inherit (config.host) username;
  owner = config.users.users.${username}.name;
in
{
  config.sops.templates = {
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
}
