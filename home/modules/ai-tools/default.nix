{ lib, ... }:

let
  skillType = lib.types.submodule {
    options = {
      owner = lib.mkOption { type = lib.types.str; };
      repo = lib.mkOption { type = lib.types.str; };
      rev = lib.mkOption { type = lib.types.str; };
      hash = lib.mkOption { type = lib.types.str; };
      skill = lib.mkOption { type = lib.types.str; };
    };
  };
in
{
  options.ai-tools = {
    claude-code = {
      enable = lib.mkEnableOption "claude code with rtk and ccline";
      skills = lib.mkOption {
        type = lib.types.listOf skillType;
        default = [ ];
      };
    };
    opencode = {
      enable = lib.mkEnableOption "opencode";
    };
    tirith = {
      enable = lib.mkEnableOption "tirith";
    };
  };

  imports = [
    ./claude-code.nix
    ./opencode.nix
    ./skills.nix
    ./tirith.nix
  ];
}
