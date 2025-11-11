{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-25.05";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = {
      url = "path:./dots/.config/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      disko,
      home-manager,
      nix-topology,
      nvim,
    }:
    {
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            ./hosts/vm/configuration.nix
            nix-topology.nixosModules.default
            {
              environment.systemPackages = [ nvim.packages.x86_64-linux.nvim ];
            }
          ];
        };
        astyanax = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            ./hosts/astyanax/configuration.nix
            nix-topology.nixosModules.default
            {
              environment.systemPackages = [ nvim.packages.x86_64-linux.nvim ];
            }
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: rec {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nix-topology.overlays.default ];
      };

      topology = import nix-topology {
        inherit pkgs;
        modules = [
          # ./topology.nix
          { nixosConfigurations = self.nixosConfigurations; }
        ];
      };
    });
}
