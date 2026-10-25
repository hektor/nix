{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.ai-tools.claude-code;
in
{
  config = lib.mkIf cfg.enable {
    programs.claude-code.enable = true;

    home.packages = with pkgs; [
      (stdenv.mkDerivation {
        name = "ccline";
        src = fetchurl {
          url = "https://github.com/Haleclipse/CCometixLine/releases/download/v1.0.8/ccline-linux-x64.tar.gz";
          hash = "sha256-Joe3Dd6uSMGi66QT6xr2oY/Tz8rA5RuKa6ckBVJIzI0=";
        };
        unpackPhase = "tar xzf $src";
        installPhase = ''
          mkdir -p $out/bin
          cp ccline $out/bin/
          chmod +x $out/bin/ccline
        '';
        meta = {
          description = "CCometixLine Linux x64 CLI (Claude Code statusline)";
          homepage = "https://github.com/Haleclipse/CCometixLine";
          license = lib.licenses.mit;
          platforms = [ "x86_64-linux" ];
        };
      })
      rtk
      mcp-nixos
    ];
  };
}
