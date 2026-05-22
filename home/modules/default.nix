{
  config,
  lib,
  pkgs,
  ...
}:

let
  moduleDirs = lib.filterAttrs (_: v: v == "directory") (builtins.readDir ./.);
  dirHasEnableOption =
    name:
    let
      nixFiles = lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".nix" n) (
        builtins.readDir ./${name}
      );
    in
    !(builtins.pathExists ./${name}/default.nix)
    || lib.any (f: lib.hasInfix "mkEnableOption" (builtins.readFile ./${name}/${f})) (
      builtins.attrNames nixFiles
    );
  withoutEnableOption = builtins.attrNames (
    lib.filterAttrs (name: _: !dirHasEnableOption name) moduleDirs
  );
in
lib.throwIf (withoutEnableOption != [ ])
  "home modules missing enable option: ${lib.concatStringsSep ", " withoutEnableOption}"
  {
    options = {
      host.username = lib.mkOption {
        type = lib.types.str;
        default = config.home.username;
      };

      nixgl.wrap = lib.mkOption {
        type = lib.types.functionTo lib.types.package;
        default = if config.lib ? nixGL then config.lib.nixGL.wrap else lib.id;
        readOnly = true;
      };

      wrapApp = lib.mkOption {
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
    };
  }
