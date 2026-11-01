{
  config,
  lib,
  ...
}:

let
  inherit (config.home) homeDirectory;
in
{
  options.my.xdg.enable = lib.mkEnableOption "XDG user directories";

  config = lib.mkIf config.my.xdg.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = false;
      download = "${homeDirectory}/dl";
      documents = "${homeDirectory}/doc";
      desktop = homeDirectory;
      music = homeDirectory;
      pictures = homeDirectory;
      projects = homeDirectory;
      publicShare = homeDirectory;
      templates = homeDirectory;
      videos = homeDirectory;
    };
  };
}
