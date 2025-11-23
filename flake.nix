{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-25.05";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:nix-community/home-manager/release-25.05";
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
      nixgl,
      firefox-addons,
      nvim,
    }@inputs:
    let
      lib = inputs.nixpkgs.lib;
      utils = import ./utils { inherit lib; };
      hostDirNames = utils.dirNames ./hosts;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
      };
    in
    {
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # <https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md>
      nixosConfigurations = lib.genAttrs hostDirNames (
        host:
        nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/${host} ];
          specialArgs = { inherit inputs; };
        }
      );
      homeConfigurations = {
        work = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/hosts/work ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
