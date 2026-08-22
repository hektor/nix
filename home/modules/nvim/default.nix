{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf config.nvim.enable {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
        SUDO_EDITOR = "nvim";
        SYSTEMD_EDITOR = "nvim";
      };
      packages = [
        inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      ];
    };
  };
}
