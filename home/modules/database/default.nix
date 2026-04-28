{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.database = {
    mssql.enable = lib.mkEnableOption "MSSQL";
    postgresql.enable = lib.mkEnableOption "PostgreSQL";
    redis.enable = lib.mkEnableOption "Redis";
  };

  config = lib.mkMerge [
    (lib.mkIf config.database.mssql.enable {
      home.packages = with pkgs; [ (config.nixgl.wrap dbeaver-bin) ];
    })
    (lib.mkIf config.database.postgresql.enable {
      home.packages = with pkgs; [ (config.nixgl.wrap pgadmin4-desktopmode) ];
    })
    (lib.mkIf config.database.postgresql.enable {
      home.packages = with pkgs; [ redis ];
    })
  ];
}
