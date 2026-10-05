{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.ai-tools.codex.enable {
    programs.codex.enable = true;
    home.packages = with pkgs; [ codex ];
  };
}
