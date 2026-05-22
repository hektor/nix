{
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

  tmux.enable = lib.mkDefault true;
}
