{
  dotsPath,
  pkgs,
  ...
}:

let
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
  home.packages = with pkgs; [
    spotifyWithWayland
  ];

  programs.ncspot = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile (dotsPath + "/.config/ncspot/config.toml"));
  };
}
