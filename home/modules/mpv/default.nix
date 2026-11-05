{ config, lib, ... }:

{
  options.mpv.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.mpv.enable {
    programs.mpv = {
      enable = true;
      config = {
        vo = "gpu";
        profile = "gpu-hq";
        hwdec = "auto";
        msg-color = "yes";
        cursor-autohide = 300;
        cursor-autohide-fs-only = "yes";
        save-position-on-quit = "yes";
        keep-open = "yes";
      };
      bindings = {
        l = "seek +5";
        h = "seek -5";
        k = "seek +30";
        j = "seek -30";
        "+" = "add video-zoom 0.1";
        "-" = "add video-zoom -0.1";
        "=" = "set video-zoom 0; set video-pan-x 0; set video-pan-y 0";
        H = "add video-pan-x 0.01";
        L = "add video-pan-x -0.01";
        K = "add video-pan-y 0.01";
        J = "add video-pan-y -0.01";
        m = "cycle mute";
      };
    };
  };
}
