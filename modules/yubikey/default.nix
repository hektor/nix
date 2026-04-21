{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.yubikey;
  inherit (config.host) username;
  formatKey = key: ":${key.handle},${key.userKey},${key.coseType},${key.options}";
  authfileContent = u: keys: u + lib.concatMapStrings formatKey keys;
in
{
  options.my.yubikey = {
    enable = mkEnableOption "yubiKey U2F authentication";

    origin = mkOption {
      type = types.str;
      default = "pam://yubi";
    };

    keys = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            handle = mkOption {
              type = types.str;
              example = "<KeyHandle1>";
            };
            userKey = mkOption {
              type = types.str;
              example = "<UserKey1>";
            };
            coseType = mkOption {
              type = types.str;
              default = "es256";
            };
            options = mkOption {
              type = types.str;
              default = "";
            };
          };
        }
      );
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    security.pam = {
      u2f = {
        enable = true;
        settings = {
          interactive = true;
          cue = true;
          inherit (cfg) origin;
          authfile = pkgs.writeText "u2f-mappings" (authfileContent username cfg.keys);
        };
      };
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };

    services.udev.packages = with pkgs; [ yubikey-personalization ];
  };
}
