{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.keyboard;
  tools = pkgs.interception-tools;
  inherit (pkgs.interception-tools-plugins) caps2esc;
in
{
  options.keyboard.enable = lib.mkEnableOption "keyboard remapping";

  config = lib.mkIf cfg.enable {
    services.interception-tools = {
      enable = true;
      plugins = [ caps2esc ];
      udevmonConfig = ''
        - JOB: ${tools}/bin/intercept -g $DEVNODE | ${caps2esc}/bin/caps2esc -m 1 | ${tools}/bin/uinput -d $DEVNODE
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK]
      '';
    };
  };
}
