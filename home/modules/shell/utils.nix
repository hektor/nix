{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.shell-utils = {
    enable = lib.mkEnableOption "shell utilities";
  };

  config = lib.mkIf config.shell-utils.enable {
    programs.fzf = {
      enable = true;
      enableBashIntegration = lib.mkDefault true;
    };

    home.packages = with pkgs; [
      ripgrep
      bat
      jq
      entr
      parallel
    ];
  };
}
