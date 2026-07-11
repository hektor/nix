{ lib, ... }:

{
  options.host = {
    username = lib.mkOption {
      type = lib.types.str;
    };

    name = lib.mkOption {
      type = lib.types.str;
    };

    role = lib.mkOption {
      type = lib.types.enum [
        "desktop"
        "embedded"
        "laptop"
        "server"
        "vm"
      ];
    };

    tags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Brussels";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
    };

    highRam = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    admin = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
