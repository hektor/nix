{ lib, ... }:

{
  options.host = {
    username = lib.mkOption {
      type = lib.types.str;
    };

    name = lib.mkOption {
      type = lib.types.str;
    };
  };
}
