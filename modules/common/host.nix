{ lib, ... }:

{
  options.host = {
    username = lib.mkOption {
      type = lib.types.str;
    };

    name = lib.mkOption {
      type = lib.types.str;
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
  };
}
