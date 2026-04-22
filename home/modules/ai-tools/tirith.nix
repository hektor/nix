{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.ai-tools.tirith;
in
{
  options.ai-tools.tirith = {
    enable = lib.mkEnableOption "tirith shell security guard";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.tirith ];
    })
    (lib.mkIf (cfg.enable && config.ai-tools.claude-code.enable) {
      home.file.".claude/hooks/tirith-check.py" = {
        source = ./tirith-check.py;
        executable = true;
      };

      home.activation.tirith-claude-code = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.tirith}/bin/tirith setup claude-code --with-mcp --scope user --force 2>/dev/null || true
      '';
    })
  ];
}
