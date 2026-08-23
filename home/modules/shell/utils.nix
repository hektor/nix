{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.shell.enable {
    programs.fzf = {
      enable = true;
      enableBashIntegration = lib.mkDefault true;
      defaultCommand = "rg --files";
      defaultOptions = [
        "--pointer='❭'"
        "--height 10%"
      ];
      fileWidget = {
        command = "rg --files";
        options = [ "--preview 'bat {} | head -500'" ];
      };
    };

    home.packages = with pkgs; [
      ripgrep
      bat
      jq
      entr
      parallel
    ];
  };
}
