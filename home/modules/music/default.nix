{
  config,
  lib,
  pkgs,
  dotsPath,
  ...
}:

let
  cfg = config.music;
  spotifyWithWayland = pkgs.symlinkJoin {
    name = "spotify";
    paths = [ pkgs.spotify ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    '';
  };
in
{
  options.music.enable = lib.mkEnableOption "music";

  config = lib.mkIf cfg.enable {
    home.packages = [ spotifyWithWayland ];

    programs.ncspot = {
      enable = true;
      settings = fromTOML (builtins.readFile (dotsPath + "/.config/ncspot/config.toml"));
    };
  };
}
