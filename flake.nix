{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-25.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/vm/configuration.nix
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.h = ./hosts/vm/home.nix;
	      }
      ];
    };
  };
}
