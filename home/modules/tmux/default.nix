{
  config,
  lib,
  pkgs,
  dotsPath,
  ...
}:

let
  cfg = config.tmux;
in
{
  options.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tmuxp
      reptyr
    ];

    programs.tmux = {
      enable = true;
      extraConfig = builtins.readFile (dotsPath + "/.config/tmux/tmux.conf");
    };
  };
}
