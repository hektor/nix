{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.ai-tools;
  rtk-version = "0.18.1";
in
{
  options.ai-tools = {
    claude-code.enable = lib.mkEnableOption "claude code with rtk and ccline";
    opencode.enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.claude-code.enable {
      home.packages = with pkgs; [
        claude-code
        (pkgs.stdenv.mkDerivation {
          name = "ccline";
          src = pkgs.fetchurl {
            url = "https://github.com/Haleclipse/CCometixLine/releases/download/v1.0.8/ccline-linux-x64.tar.gz";
            hash = "sha256-Joe3Dd6uSMGi66QT6xr2oY/Tz8rA5RuKa6ckBVJIzI0=";
          };

          unpackPhase = ''
            tar xzf $src
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ccline $out/bin/
            chmod +x $out/bin/ccline
          '';

          meta = with pkgs.lib; {
            description = "CCometixLine Linux x64 CLI (Claude Code statusline)";
            homepage = "https://github.com/Haleclipse/CCometixLine";
            license = licenses.mit;
            platforms = [ "x86_64-linux" ];
          };
        })
        (pkgs.stdenv.mkDerivation {
          name = "rtk-${rtk-version}";
          version = rtk-version;
          src = pkgs.fetchurl {
            url = "https://github.com/rtk-ai/rtk/releases/download/v${rtk-version}/rtk-x86_64-unknown-linux-gnu.tar.gz";
            hash = "sha256-XoTia5K8b00OzcKYCufwx8ApkAS31DxUCpGSU0jFs2Q=";
          };

          unpackPhase = ''
            tar xzf $src
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp rtk $out/bin/
            chmod +x $out/bin/rtk
          '';

          meta = with pkgs.lib; {
            description = "RTK - AI coding tool enhancer";
            homepage = "https://www.rtk-ai.app";
            license = licenses.mit;
            platforms = [ "x86_64-linux" ];
          };
        })
        mcp-nixos
      ];
    })
    (lib.mkIf cfg.opencode.enable {
      home.packages = with pkgs; [
        opencode
      ];
    })
  ];
}
