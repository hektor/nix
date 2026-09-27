{
  config,
  lib,
  pkgs,
  dotsPath,
  ...
}:

{
  options.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf config.tmux.enable {
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
