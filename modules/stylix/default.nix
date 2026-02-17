{
  config,
  inputs,
  pkgs,
  ...
}:

let
  theme = import ./theme.nix { inherit pkgs; };
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    inherit (theme)
      polarity
      base16Scheme
      override
      image
      ;
    fonts = {
      monospace = theme.monospaceFont;
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
    autoEnable = true;
  };

  home-manager.sharedModules = [
    {
      stylix.targets = {
        firefox.profileNames = [ "default" ];
        librewolf.profileNames = [ "default" ];
        kitty.variant256Colors = true;
        gnome.enable = false;
        gtk.enable = false;
        nixvim.enable = false;
      };
    }
  ];
}
