{ inputs, outputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.default
  ];

  system.stateVersion = "25.05";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
}
