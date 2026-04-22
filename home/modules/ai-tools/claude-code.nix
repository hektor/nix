{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.ai-tools.claude-code;
  rtk-version = "0.18.1";
in
{
  options.ai-tools.claude-code.enable = lib.mkEnableOption "claude code with rtk and ccline";

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
      (stdenv.mkDerivation {
        name = "rtk-${rtk-version}";
        version = rtk-version;
        src = fetchurl {
          url = "https://github.com/rtk-ai/rtk/releases/download/v${rtk-version}/rtk-x86_64-unknown-linux-gnu.tar.gz";
          hash = "sha256-XoTia5K8b00OzcKYCufwx8ApkAS31DxUCpGSU0jFs2Q=";
        };
        unpackPhase = "tar xzf $src";
        installPhase = ''
          mkdir -p $out/bin
          cp rtk $out/bin/
          chmod +x $out/bin/rtk
        '';
        meta = {
          description = "RTK - AI coding tool enhancer";
          homepage = "https://www.rtk-ai.app";
          license = lib.licenses.mit;
          platforms = [ "x86_64-linux" ];
        };
      })
      mcp-nixos
    ];
  };
}
