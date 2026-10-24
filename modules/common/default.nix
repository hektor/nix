{ lib, ... }:

{
  imports = [
    ./embedded.nix
    ./home-manager.nix
    ./host.nix
    ./nix.nix
    ./nixpkgs.nix
    ./upgrades.nix
  ];

  config = {
    system.stateVersion = lib.mkDefault "25.05";

    environment.defaultPackages = lib.mkForce [ ];
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
