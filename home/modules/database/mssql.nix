{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.database.mssql.enable {
    home.packages = with pkgs; [ (config.nixgl.wrap dbeaver-bin) ];
  };
}
