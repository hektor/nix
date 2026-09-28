{
  config,
  lib,
  ...
}:

{
  options.keyboard.vortexCore.enable = lib.mkEnableOption "Vortex Core keyboard configuration files";

  config = lib.mkIf config.keyboard.vortexCore.enable {
    home.file.".vortex-core" = {
      source = ./vortex-core;
      recursive = true;
    };
  };
}
