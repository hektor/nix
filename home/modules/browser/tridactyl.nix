{
  config,
  lib,
  ...
}:

let
  browsers = [
    config.browser.primary
    config.browser.secondary
  ];
in
{
  config = lib.mkIf (lib.elem "firefox" browsers || lib.elem "librewolf" browsers) {
    xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
  };
}
