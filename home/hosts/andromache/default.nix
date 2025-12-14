{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    (import ../astyanax {
      inherit inputs;
      inherit config;
      inherit pkgs;
    })
    (import ../../modules/anki.nix {
      inherit config;
      inherit pkgs;
    })
  ];

  programs.taskwarrior.config.recurrence = lib.mkForce "on";
}
