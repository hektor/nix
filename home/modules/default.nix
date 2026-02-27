{ config, lib, pkgs, ... }:

{
  options.nixgl.wrap = lib.mkOption {
    type = lib.types.functionTo lib.types.package;
    default = if config.lib ? nixGL then config.lib.nixGL.wrap else lib.id;
    readOnly = true;
  };

  options.wrapApp = lib.mkOption {
    type = lib.types.raw;
    default =
      pkg: flags:
      if config.lib ? nixGL then
        pkg.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
          postInstall = (old.postInstall or "") + ''
            wrapProgram $out/bin/${pkg.meta.mainProgram} --add-flags "${flags}"
          '';
        })
      else
        pkg;
    readOnly = true;
  };
}
