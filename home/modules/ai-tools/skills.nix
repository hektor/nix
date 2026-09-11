{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.ai-tools.claude-code;

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
  config = lib.mkIf cfg.enable {
    home.file = builtins.listToAttrs (map fetchSkill cfg.skills);
  };
}
