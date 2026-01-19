{ pkgs, ... }:

{
  config = {
    home.packages = [ pkgs.kitty ];
    programs.bash.shellAliases = {
      icat = "kitty +kitten icat";
    };
  };
}
