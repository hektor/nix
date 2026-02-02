{ lib, config, ... }:
{
  options.ssh = {
    authorizedHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    username = lib.mkOption {
      type = lib.types.str;
      default = "h";
    };
    publicHostname = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  # auto generate authorized_keys from `authorizedHosts`
  config.users.users.${config.ssh.username}.openssh.authorizedKeys.keys = lib.flatten (
    map (
      hostname:
      let
        keyFile = ../../hosts/${hostname}/ssh_user.pub;
      in
      lib.optionals (builtins.pathExists keyFile) (lib.splitString "\n" (builtins.readFile keyFile))
    ) config.ssh.authorizedHosts
  );
}
