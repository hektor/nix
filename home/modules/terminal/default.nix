{
  config,
  lib,
  pkgs,
  dotsPath,
  ...
}:

let
  cfg = config.terminal;
in
{
  options.terminal.enable = lib.mkEnableOption "terminal";

  config = lib.mkIf cfg.enable {
    programs.bash.shellAliases = {
      icat = "kitty +kitten icat";
    };

    programs.kitty = {
      enable = true;
      package = config.nixgl.wrap pkgs.kitty;
      extraConfig = builtins.readFile (dotsPath + "/.config/kitty/kitty.conf");
    };

    home.file.".config/kitty/nvim.conf".source = dotsPath + "/.config/kitty/nvim.conf";
  };
}
