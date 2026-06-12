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
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options = {
    secrets = {
      enable = lib.mkEnableOption "secrets management";

      sopsDir = lib.mkOption {
        type = lib.types.str;
        default = "${toString inputs.nix-secrets}/secrets";
      };

      groups = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf lib.types.str);
        default = { };
      };

      owner = lib.mkOption {
        type = lib.types.unspecified;
      };

      nixSigningKey = {
        enable = lib.mkEnableOption "nix signing key configuration";
      };

      yubikey = {
        enable = lib.mkEnableOption "set up Yubikey";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    secrets = {
      inherit owner;
      groups = {
        email = [
          "personal"
          "work"
        ];
        nix = lib.optional cfg.nixSigningKey.enable "signing-key";
      };
    };

    sops = {
      secrets = myUtils.mkSopsSecrets sopsDir owner cfg.groups;
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
