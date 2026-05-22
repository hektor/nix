{
  lib,
  config,
  ...
}:

let
  inherit (config.host) username;
  adminHosts = (import ../../utils { inherit lib; }).adminHosts ../../hosts;
in
{
  options.ssh = {
    authorizedHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf config.ssh.enable {
    users.users.${username}.openssh.authorizedKeys.keys =
      lib.flatten (
        map (
          hostname:
          let
            keyFile = ../../hosts/${hostname}/ssh_user.pub;
          in
          lib.optionals (builtins.pathExists keyFile) (lib.splitString "\n" (builtins.readFile keyFile))
        ) ((builtins.filter (h: h != config.host.name) adminHosts) ++ config.ssh.authorizedHosts)
      )
      ++ lib.splitString "\n" (builtins.readFile ./ssh_bak.pub);
  };
}
