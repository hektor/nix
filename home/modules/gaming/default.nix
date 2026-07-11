{
  config,
  lib,
  ...
}:

{
  options.gaming.enable = lib.mkEnableOption "gaming";

  config = lib.mkIf config.gaming.enable {
    xdg.configFile."lutris/system.yml".text = lib.generators.toJSON { } {
      system.game_path = "${config.home.homeDirectory}/games";
    };
  };
}
