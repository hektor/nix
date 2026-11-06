{
  lib,
  inputs,
  pkgs,
  config,
  lib',
  ...
}:

let
  cfg = config.secrets;
  inherit (config.host) username;
  sopsDir = "${toString inputs.nix-secrets}/secrets";
  owner = username;

  system = {
    email = [
      "personal"
      "work"
    ];
  }
  // lib.filterAttrs (_: lib.isList) cfg;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.secrets = lib.mkOption {
    default = { };
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf (lib.types.listOf lib.types.str);

      options = {
        enable = lib.mkEnableOption "secrets management";

        user = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          default = { };
        };

        owner = lib.mkOption {
          type = lib.types.unspecified;
          default = owner;
        };

        yubikey = {
          enable = lib.mkEnableOption "set up Yubikey";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = lib'.mkSopsSecrets sopsDir null system // lib'.mkSopsSecrets sopsDir owner cfg.user;

    nix.settings.secret-key-files = lib.mkIf (system ? nix) [
      config.sops.secrets."nix/signing-key".path
    ];

    services = {
      pcscd.enable = true;
      udev.packages = lib.mkIf cfg.yubikey.enable [
        pkgs.yubikey-personalization
        pkgs.libfido2
      ];
    };
  };
}
