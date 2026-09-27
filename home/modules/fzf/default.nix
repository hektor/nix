{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.fzf.enable = lib.mkEnableOption "fzf";

  config = lib.mkIf config.fzf.enable {
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
    ];
  };
}
