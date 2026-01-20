{ pkgs, ... }:

{
  config = {
    home.packages = [ pkgs.kitty ];
    programs.bash.shellAliases = {
      icat = "kitty +kitten icat";
    };

    home.file = {
      ".config/kitty/kitty.conf".source = ../../dots/.config/kitty/kitty.conf;
      ".config/kitty/nvim.conf".source = ../../dots/.config/kitty/nvim.conf;
      ".config/kitty/themes/zenwritten_light.conf".source =
        ../../dots/.config/kitty/themes/zenwritten_light.conf;
      ".config/kitty/themes/zenwritten_dark.conf".source =
        ../../dots/.config/kitty/themes/zenwritten_dark.conf;
    };
  };
}
