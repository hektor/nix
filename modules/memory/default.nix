{ lib, ... }:

{
  imports = [
    ./oom.nix
    ./zram.nix
  ];

  options.memory = {
    oom.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
    zram.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };
}
