{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.cloud.azure.enable {
    home.packages = with pkgs; [ azure-cli ];
  };
}
