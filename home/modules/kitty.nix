{
  pkgs,
  config,
  dotsPath,
  ...
}:

{
  config = {
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
