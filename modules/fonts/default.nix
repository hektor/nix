{ pkgs, ... }:

{
  imports = [
    ./iosevka.nix
  ];

  fonts = {
    # disable default font packages (see https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/fonts/packages.nix)
    enableDefaultPackages = false;
    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
    ];
  };
}
