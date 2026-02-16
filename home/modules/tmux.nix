{
  pkgs,
  dotsPath,
  ...
}:
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

    home.file = {
      ".config/tmux/tmux.regular.conf".source = dotsPath + "/.config/tmux/tmux.regular.conf";
      ".config/tmux/hooks/tmux.ssh.conf".source = dotsPath + "/.config/tmux/hooks/tmux.ssh.conf";
      ".config/tmux/hooks/tmux.regular.conf".source = dotsPath + "/.config/tmux/hooks/tmux.regular.conf";
    };
  };
}
