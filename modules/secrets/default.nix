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
  inherit (cfg) sopsDir;
  owner = config.users.users.${cfg.username}.name;
  mkSopsSecrets = myUtils.mkSopsSecrets sopsDir;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options = {
    secrets = {
      username = lib.mkOption {
        type = lib.types.str;
      };

      sopsDir = lib.mkOption {
        type = lib.types.str;
        default = "${toString inputs.nix-secrets}/secrets";
      };

      nixSigningKey = {
        enable = lib.mkEnableOption "nix signing key configuration";
      };

      yubikey = {
        enable = lib.mkEnableOption "set up Yubikey";
      };
    };
  };

  config = {
    sops = {
      # for yubikey, generate as follows:
      # ```
      # age-plugin-yubikey --identity > <keyfile-path>
      # ```
      age.keyFile = "/home/${cfg.username}/.config/sops/age/keys.txt";

      secrets = lib.mkMerge [
        (mkSopsSecrets "email" [ "personal" "work" ] { inherit owner; })
        (lib.mkIf cfg.nixSigningKey.enable {
          nix-signing-key = {
            sopsFile = "${sopsDir}/nix.yaml";
            key = "signing-key";
            inherit owner;
          };
        })
      ];
    };

    nix.settings.secret-key-files = lib.mkIf cfg.nixSigningKey.enable [
      config.sops.secrets.nix-signing-key.path
    ];

    services = {
      pcscd.enable = true; # needed for age-plugin-yubikey?
      udev.packages = lib.mkIf cfg.yubikey.enable [
        pkgs.yubikey-personalization
        pkgs.libfido2
      ];
    };
  };
}
