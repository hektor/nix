{
  config,
  lib,
  pkgs,
  inputs,
  lib',
  osConfig ? null,
  ...
}:

let
  cfg = config.secrets;
  sops = lib'.sopsAvailability config osConfig;
  standalone = !sops.osAvailable;

  sopsDir = "${toString inputs.nix-secrets}/secrets";
in
{
  imports = [ ./vault.nix ];

  options.secrets = {
    enable = lib.mkEnableOption "secrets";
    vault.enable = lib.mkEnableOption "vault CLI";

    files = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    };

    templates = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            path = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            content = lib.mkOption {
              type = lib.types.str;
            };
          };
        }
      );
    };

    path = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
    };

    templatePath = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
    };
  };

  config = lib.mkMerge [
    {
      secrets.path = lib.optionalAttrs sops.available (
        lib.mapAttrs (_: secret: secret.path) sops.secrets
      );

      secrets.templatePath = lib.optionalAttrs sops.available (
        lib.mapAttrs (_: template: template.path) sops.templates
      );
    }
    (lib.mkIf cfg.enable (
      lib.optionalAttrs standalone {
        sops = {
          secrets = lib'.mkSopsSecrets sopsDir null cfg.files;

          templates = lib.mapAttrs (
            _: t:
            {
              inherit (t) content;
            }
            // lib.optionalAttrs (t.path != null) {
              path = "${config.home.homeDirectory}/${t.path}";
            }
          ) cfg.templates;
        };
      }
      // {
        home.packages = [
          pkgs.age
          pkgs.age-plugin-yubikey
          pkgs.sops
        ];

        warnings = lib.optional (
          !sops.available && (cfg.files != { } || cfg.templates != { })
        ) "secrets declared, but sops unavailable.";
      }
    ))
  ];
}
