{
  pkgs,
  ...
}:
{
  config = {
    home.packages = with pkgs; [
      aider-chat
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
      claude-code
      # (config.lib.nixGL.wrap code-cursor)
      github-copilot-cli
      mcp-nixos
      opencode
    ];
  };
}
