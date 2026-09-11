{ lib, ... }:

{
  options.database = {
    mssql = {
      enable = lib.mkEnableOption "MSSQL";
    };
    postgresql = {
      enable = lib.mkEnableOption "PostgreSQL";
    };
    redis = {
      enable = lib.mkEnableOption "Redis";
    };
  };

  imports = [
    ./mssql.nix
    ./postgresql.nix
    ./redis.nix
  ];
}
