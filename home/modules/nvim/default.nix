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

        PAGER = "nvimpager";
        MANWIDTH = "80";
      };
      packages = with pkgs; [
        inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
        nvimpager
      ];
    };
  };
}
