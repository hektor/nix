{ pkgs, config, lib, dotsPath, ... }:

{
  config = {
    home.packages = [
      (if config.lib ? nixGL
        then config.lib.nixGL.wrap pkgs.kitty
        else pkgs.kitty)
    ];
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
