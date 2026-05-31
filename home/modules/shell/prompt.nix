{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.shell.enable {
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
