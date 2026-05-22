{
  config,
  lib,
  ...
}:

{
  imports = [
    ./bash.nix
    ./utils.nix
    ./prompt.nix
    ../tmux
  ];

  options.shell.enable = lib.mkEnableOption "shell";

  config = lib.mkIf config.shell.enable {
    tmux.enable = lib.mkDefault true;
  };
}
