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
  ];

  options.shell.enable = lib.mkEnableOption "shell";

  config = lib.mkIf config.shell.enable {
    tmux.enable = lib.mkDefault true;
  };
}
