{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.pandoc = {
    enable = lib.mkEnableOption "pandoc";
  };

  config = lib.mkIf config.pandoc.enable {
    home.packages = with pkgs; [
      haskellPackages.pandoc-crossref
      pandoc
      texliveSmall
    ];
  };
}
