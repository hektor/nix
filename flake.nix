{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-25.05";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      home-manager,
    }:
    {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            ./hosts/vm/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.h = ./hosts/vm/home.nix;
            }
          ];
        };
      };
    };
}
