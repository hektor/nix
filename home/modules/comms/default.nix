{ lib, ... }:

{
  options.comms = {
    signal = {
      enable = lib.mkEnableOption "signal";
    };
    teams = {
      enable = lib.mkEnableOption "teams";
    };
  };

  imports = [
    ./signal.nix
    ./teams.nix
  ];
}
