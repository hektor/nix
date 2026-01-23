{
  pkgs,
  dotsPath,
  ...
}:
{
  config = {
    home.packages = with pkgs; [
      tmux
      tmuxp
      reptyr
    ];

    home.file = {
      ".config/tmux/tmux.conf".source = dotsPath + "/.config/tmux/tmux.conf";
      ".config/tmux/tmux.regular.conf".source = dotsPath + "/.config/tmux/tmux.regular.conf";
      ".config/tmux/themes/zenwritten_light.tmux".source =
        dotsPath + "/.config/tmux/themes/zenwritten_light.tmux";
      ".config/tmux/themes/zenwritten_dark.tmux".source =
        dotsPath + "/.config/tmux/themes/zenwritten_dark.tmux";
      ".config/tmux/hooks/tmux.ssh.conf".source = dotsPath + "/.config/tmux/hooks/tmux.ssh.conf";
      ".config/tmux/hooks/tmux.regular.conf".source = dotsPath + "/.config/tmux/hooks/tmux.regular.conf";
    };
  };
}
