{
  dotsPath,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ncspot
    # (if config.lib ? nixGL then config.lib.nixGL.wrap spotify else spotify)
  ];

  home.file = {
    ".config/ncspot/config.toml".source = dotsPath + "/.config/ncspot/config.toml";
  };
}
