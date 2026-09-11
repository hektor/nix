{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.database.postgresql.enable {
    home.packages = with pkgs; [ (config.nixgl.wrap pgadmin4-desktopmode) ];
  };
}
