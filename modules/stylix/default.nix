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
      stylix.targets = import ./targets.nix;
    }
  ];
}
