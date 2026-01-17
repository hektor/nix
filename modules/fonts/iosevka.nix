{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      (iosevka-bin.override { variant = "SGr-IosevkaTermSS08"; })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Iosevka Term SS08" ];
      };
    };
  };
}
