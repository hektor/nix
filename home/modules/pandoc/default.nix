{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pandoc;
in
{
  options.pandoc = {
    enable = lib.mkEnableOption "pandoc";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      haskellPackages.pandoc-crossref
      pandoc
      texliveSmall
    ];
  };
}
