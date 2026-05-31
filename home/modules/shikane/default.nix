{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.shikane.enable = lib.mkEnableOption "shikane";

  config = lib.mkIf config.shikane.enable {
    home.packages = with pkgs; [ (config.nixgl.wrap wdisplays) ];
    services.shikane.enable = true;
    home.file.".config/shikane/config.toml" = {
      force = true;
      text = ''
        [[profile]]
        name = "work"

        [[profile.output]]
        enable = true
        search = ["m=Unknown", "s=", "v=Unknown"]
        mode = "2880x1800@120Hz"
        position = "288,3240"
        scale = 1.5
        transform = "normal"
        adaptive_sync = false

        [[profile.output]]
        enable = true
        search = ["m=Q27P1B", "s=GNXM2HA196769", "v=PNP(AOC)"]
        mode = "2560x1440@59.951Hz"
        position = "116,1800"
        scale = 1.0
        transform = "normal"
        adaptive_sync = false

        [[profile.output]]
        enable = true
        search = ["m=PHL 243S7", "s=UHB1923012753", "v=Philips Consumer Electronics Company"]
        mode = "1920x1080@60Hz"
        position = "2676,1800"
        scale = 1.0
        transform = "270"
        adaptive_sync = false

        [[profile]]
        name = "home"

        [[profile.output]]
        enable = true
        search = ["m=Unknown", "s=Unknown", "v=Unknown"]
        mode = "2880x1800@60.001Hz"
        position = "185,1440"
        scale = 1.75
        transform = "normal"
        adaptive_sync = false

        [[profile.output]]
        enable = true
        search = ["m=PHL 276E8V", "s=0x0000046D", "v=Philips Consumer Electronics Company"]
        mode = "3840x2160@59.996Hz"
        position = "1500,0"
        scale = 1.5
        transform = "normal"
        adaptive_sync = false
      '';
    };
  };
}
