{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zk;
in
{
  options.zk = {
    enable = lib.mkEnableOption "zettelkasten";
    path = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.zk";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables.ZK_PATH = cfg.path;
      packages = [
        (pkgs.writeShellApplication {
          name = "zk";
          runtimeInputs = with pkgs; [
            tmux
            gh
          ];
          runtimeEnv.ZK_PATH = cfg.path;
          text = builtins.readFile ./scripts/zk.sh;
        })
      ];
    };
  };
}
