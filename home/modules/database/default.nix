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
  };

  config = lib.mkMerge [
    (lib.mkIf config.database.mssql.enable {
      home.packages = [ (config.nixgl.wrap pkgs.dbeaver-bin) ];
    })
    (lib.mkIf config.database.postgresql.enable {
      home.packages = [ (config.nixgl.wrap pkgs.pgadmin4-desktopmode) ];
    })
  ];
}
