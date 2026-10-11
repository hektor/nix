{
  lib,
  config,
  outputs,
  paths,
  myUtils,
  pkgs,
  ...
}:

let
  hosts = myUtils.dirNames paths.hosts;
  interfaces = host: outputs.nixosConfigurations.${host}.config.wol.interfaces;
in
{
  options.wol = {
    wakes = lib.mkOption {
      type = lib.types.listOf (lib.types.enum hosts);
    };

    interfaces = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            macAddress = lib.mkOption { type = lib.types.str; };
          };
        }
      );
    };
  };

  config = {
    assertions = map (host: {
      assertion = interfaces host != { };
      message = "cannot set up wake-on-lan for '${host}' as it declares no 'wol.interfaces'.";
    }) config.wol.wakes;

    networking.interfaces = lib.mapAttrs (_: iface: {
      wakeOnLan.enable = true;
      inherit (iface) macAddress;
    }) config.wol.interfaces;

    environment.systemPackages = map (
      host:
      let
        macAddresses = lib.mapAttrsToList (_: interface: interface.macAddress) (interfaces host);
      in
      pkgs.writeShellApplication {
        name = "wol-${host}";
        runtimeInputs = [ pkgs.wakeonlan ];
        text = ''
          wakeonlan ${lib.escapeShellArgs macAddresses}
        '';
      }
    ) config.wol.wakes;
  };
}
