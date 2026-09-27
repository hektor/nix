{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.prompt.enable {
    programs.starship = {
      enable = true;
      settings = {
        git_status = {
          ahead = "⇡$\{count\}";
        };
      };
    };
  };
}
