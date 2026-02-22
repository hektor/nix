{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/hektor/nix-secrets?shallow=1&ref=main";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = {
      url = "path:./dots/.config/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixgl,
      git-hooks,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (inputs.nixpkgs) lib;
      utils = import ./utils { inherit lib; };
      hostDirNames = utils.dirNames ./hosts;
      system = "x86_64-linux";
      dotsPath = ./dots;
      gitHooks = import ./git-hooks.nix {
        inherit nixpkgs git-hooks system;
        src = ./.;
      };
    in
    {
      nix.nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
      ]; # <https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md>
      nixosConfigurations =
        (lib.genAttrs hostDirNames (
          host:
          nixpkgs.lib.nixosSystem {
            system = import ./hosts/${host}/system.nix;
            modules = [ ./hosts/${host} ];
            specialArgs = {
              inherit inputs outputs dotsPath;
            };
          }
        ))
        // {
          sd-image-orange-pi-aarch64 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              ./images/sd-image-orange-pi-aarch64.nix
              {
                nixpkgs.crossSystem = {
                  system = "aarch64-linux";
                };
              }
            ];
            specialArgs = {
              inherit inputs outputs dotsPath;
            };
          };
          sd-image-raspberry-pi-aarch64 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              ./images/sd-image-raspberry-pi-aarch64.nix
              {
                nixpkgs.crossSystem = {
                  system = "aarch64-linux";
                };
              }
            ];
            specialArgs = {
              inherit inputs outputs dotsPath;
            };
          };
        };

      homeConfigurations = {
        work = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nixgl.overlay ];
          };
          modules = [ ./home/hosts/work ];
          extraSpecialArgs = {
            inherit inputs outputs dotsPath;
          };
        };
      };

      apps.${system}.colmena = inputs.colmena.apps.${system}.default;
      colmenaHive = import ./deploy/colmena.nix {
        inherit
          self
          inputs
          ;
      };

      checks.${system} = gitHooks.checks;
      formatter.${system} = gitHooks.formatter;
      devShells.${system} = gitHooks.devShells;

      images.sd-image-orange-pi-aarch64 =
        self.nixosConfigurations.sd-image-orange-pi-aarch64.config.system.build.sdImage;
      images.sd-image-raspberry-pi-aarch64 =
        self.nixosConfigurations.sd-image-raspberry-pi-aarch64.config.system.build.sdImage;
    };
}
