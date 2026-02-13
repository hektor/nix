{
  pkgs,
  config,
  dotsPath,
  ...
}:

{
  config = {
    home.packages = [ (config.nixgl.wrap pkgs.kitty) ];
    programs.bash.shellAliases = {
      icat = "kitty +kitten icat";
    };

    home.file = {
      ".config/kitty/kitty.conf".source = dotsPath + "/.config/kitty/kitty.conf";
      ".config/kitty/nvim.conf".source = dotsPath + "/.config/kitty/nvim.conf";
      ".config/kitty/themes/zenwritten_light.conf".source =
        dotsPath + "/.config/kitty/themes/zenwritten_light.conf";
      ".config/kitty/themes/zenwritten_dark.conf".source =
        dotsPath + "/.config/kitty/themes/zenwritten_dark.conf";
    };
  };
}
