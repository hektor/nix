{
  lib,
  inputs,
  pkgs,
  config,
  myUtils,
  ...
}:

let
  cfg = config.secrets;
  inherit (config.host) username;
  inherit (cfg) sopsDir;
  owner = config.users.users.${username}.name;

  system = {
    email = [
      "personal"
      "work"
    ];
    nix = lib.optional cfg.nixSigningKey.enable "signing-key";
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

        sopsDir = lib.mkOption {
          type = lib.types.str;
          default = "${toString inputs.nix-secrets}/secrets";
        };

        user = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          default = { };
        };

        owner = lib.mkOption {
          type = lib.types.unspecified;
          default = owner;
        };

        nixSigningKey = {
          enable = lib.mkEnableOption "nix signing key configuration";
        };

        yubikey = {
          enable = lib.mkEnableOption "set up Yubikey";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets = myUtils.mkSopsSecrets sopsDir system // myUtils.mkSopsUserSecrets sopsDir owner cfg.user;
    };

    nix.settings.secret-key-files = lib.mkIf cfg.nixSigningKey.enable [
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
