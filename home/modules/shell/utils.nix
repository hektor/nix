{
  lib,
  pkgs,
  ...
}:
{
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
}
