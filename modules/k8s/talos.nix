{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.host) username;
in
{
  config = lib.mkIf config.k8s.talos.enable (
    lib.mkMerge [
      (lib.mkIf (config.k8s.talos.platform == "docker") {
        docker.enable = true;
        assertions = [
          {
            assertion = !config.docker.rootless;
            message = "talos in docker needs 'docker.rootless = false;'";
          }
        ];
      })
      (lib.mkIf (config.k8s.talos.platform == "qemu") {
        users.users.${username}.extraGroups = [ "kvm" ];
        environment.systemPackages = [ pkgs.qemu ];
      })
    ]
  );
}
