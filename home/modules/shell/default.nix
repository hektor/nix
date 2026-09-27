{
  config,
  lib,
  ...
}:

{
  imports = [
    ./bash.nix
    ./prompt.nix
    ./utils.nix
  ];

  options = {
    shell.enable = lib.mkEnableOption "shell";
    prompt.enable = lib.mkEnableOption "shell prompt" // {
      default = config.shell.enable;
    };
    utils.enable = lib.mkEnableOption "shell utilities" // {
      default = config.shell.enable;
    };
  };

  config = lib.mkIf config.shell.enable {
    fzf.enable = lib.mkDefault true;
    readline.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
  };
}
