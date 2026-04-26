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
      default = config.home.homeDirectory + "/.zk";
      description = "Path to the zettelkasten directory";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables.ZK_PATH = cfg.path;
      packages = [
        (pkgs.writeShellApplication {
          name = "zk";
          runtimeInputs = with pkgs; [ tmux ];
          text = builtins.readFile ./scripts/zk.sh;
        })

        (pkgs.writeShellApplication {
          name = "save-zk";
          runtimeInputs = with pkgs; [ git ];
          text = builtins.readFile ./scripts/save-zk.sh;
        })

        (pkgs.writeShellApplication {
          name = "setup-zk";
          runtimeInputs = with pkgs; [ gh ];
          text = builtins.readFile ./scripts/setup-zk.sh;
        })
      ];
    };
  };
}
