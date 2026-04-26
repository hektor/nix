{ pkgs, dotsPath, ... }:

{
  config = {
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
