{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.nvim;
in
{
  options.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];
  };
}
