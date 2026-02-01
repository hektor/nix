{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
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
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      disko,
      sops-nix,
      nix-secrets,
      home-manager,
      nix-on-droid,
      nixgl,
      firefox-addons,
      nvim,
      colmena,
    }@inputs:
    let
      inherit (self) outputs;
      inherit (inputs.nixpkgs) lib;
      utils = import ./utils { inherit lib; };
      hostDirNames = utils.dirNames ./hosts;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
      };
      dotsPath = ./dots;
    in
    {
      nix.nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
      ]; # <https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md>
      nixosConfigurations =
        (lib.genAttrs (lib.filter (h: h != "eetion") hostDirNames) (
          host:
          nixpkgs.lib.nixosSystem {
            modules = [ ./hosts/${host} ];
            specialArgs = {
              inherit inputs outputs dotsPath;
            };
          }
        ))
        // {
          eetion = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [ ./hosts/eetion ];
            specialArgs = {
              inherit inputs outputs dotsPath;
            };
          };
          sd-image-aarch64 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              ./images/sd-image-aarch64.nix
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
          inherit pkgs;
          modules = [ ./home/hosts/work ];
          extraSpecialArgs = {
            inherit inputs outputs dotsPath;
          };
        };
      };
      # https://github.com/nix-community/nix-on-droid/blob/master/templates/advanced/flake.nix
      nixOnDroidConfigurations = {
        pixel = nix-on-droid.lib.nixOnDroidConfiguration {
          modules = [ ./phone ];
          extraSpecialArgs = {
            inherit inputs outputs dotsPath;
          };
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            overlays = [ nix-on-droid.overlays.default ];
          };
          home-manager-path = home-manager.outPath;
        };
      };

      colmenaHive = import ./deploy/colmena.nix {
        inherit
          self
          inputs
          ;
      };

      images.sd-image-aarch64 = self.nixosConfigurations.sd-image-aarch64.config.system.build.sdImage;
    };
}
