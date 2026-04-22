{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.ai-tools.claude-code;

  skillType = lib.types.submodule {
    options = {
      owner = lib.mkOption { type = lib.types.str; };
      repo = lib.mkOption { type = lib.types.str; };
      rev = lib.mkOption { type = lib.types.str; };
      hash = lib.mkOption { type = lib.types.str; };
      skill = lib.mkOption { type = lib.types.str; };
    };
  };

  fetchSkill =
    skill:
    let
      src = pkgs.fetchFromGitHub {
        inherit (skill)
          owner
          repo
          rev
          hash
          ;
      };
    in
    {
      name = ".claude/skills/${skill.skill}";
      value = {
        source = "${src}/${skill.skill}";
        recursive = true;
      };
    };
in
{
  options.ai-tools.claude-code.skills = lib.mkOption {
    type = lib.types.listOf skillType;
    default = [ ];
  };

  config = lib.mkIf cfg.enable {
    home.file = builtins.listToAttrs (map fetchSkill cfg.skills);
  };
}
