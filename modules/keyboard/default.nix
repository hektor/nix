{ pkgs, ... }:

with pkgs;
let
  tools = interception-tools;
  caps2esc = interception-tools-plugins.caps2esc;
in
{
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
}
