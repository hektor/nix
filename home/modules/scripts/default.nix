{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  options.scripts.enable = lib.mkOption { default = false; };

  config = lib.mkIf config.scripts.enable {
    home.packages = [ inputs.scripts.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
