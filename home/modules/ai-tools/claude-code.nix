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
      (rustPlatform.buildRustPackage (finalAttrs: {
        pname = "ccometixline";
        version = "2.0.1";
        src = fetchFromGitHub {
          owner = "Haleclipse";
          repo = "CCometixLine";
          tag = "v${finalAttrs.version}";
          hash = "sha256-tzEo+8M86C6EdN31rDVqt8+SCYqeEXRCVFsbtbW41XY=";
        };
        cargoHash = "sha256-dTsuyklpaiYqp5Rq1Q7YUBrmQUH42ve2UY+MwUqF7Ek=";
        checkFlags = [ "--skip=git::tests::detects_repositories_without_spawning_git" ];
        postInstall = "mv $out/bin/ccometixline $out/bin/ccline";
        meta = {
          description = "CCometixLine (ccline) - Claude Code statusline tool";
          homepage = "https://github.com/Haleclipse/CCometixLine";
          license = lib.licenses.mit;
          mainProgram = "ccline";
          platforms = lib.platforms.unix;
        };
      }))
      rtk
      mcp-nixos
    ];
  };
}
