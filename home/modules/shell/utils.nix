{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.utils.enable {
    home.packages = with pkgs; [
      jq
      entr
      parallel
    ];
  };
}
