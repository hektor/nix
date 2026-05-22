{
  config,
  lib,
  ...
}:

let
  cfg = config.k8s.k9s;
in
{
  options.k8s.k9s.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    programs.k9s = {
      enable = true;
      settings.k9s = {
        ui = {
          logoless = true;
          reactive = true;
        };
      };
    };
  };
}
