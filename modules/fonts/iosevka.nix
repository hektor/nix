{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    (iosevka-bin.override { variant = "SGr-IosevkaTermSS08"; })
  ];
}
