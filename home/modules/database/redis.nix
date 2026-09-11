{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.database.redis.enable {
    home.packages = with pkgs; [ redis ];
  };
}
