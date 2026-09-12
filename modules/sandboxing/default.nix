{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.sandboxing;
in
{
  options.sandboxing.enable = lib.mkOption { default = false; };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bubblewrap ];
  };
}
