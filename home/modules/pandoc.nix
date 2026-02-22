{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.pandoc;
in
{
  options.pandoc.enable = lib.mkEnableOption "pandoc with crossref";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pandoc
      haskellPackages.pandoc-crossref
    ];
  };
}
