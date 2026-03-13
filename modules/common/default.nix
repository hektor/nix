{
  inputs,
  outputs,
  dotsPath,
  myUtils,
  config,
  ...
}:

let
  inherit (inputs.nixpkgs) lib;
in
{
  imports = [
    inputs.home-manager.nixosModules.default
    ./host.nix
  ];

  options.nixpkgs.allowedUnfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    system.stateVersion = lib.mkDefault "25.05";

    nix = {
      optimise = {
        automatic = true;
        dates = [ "05:00" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    system.autoUpgrade = {
      enable = true;
      flags = [
        "--recreate-lock-file"
        "--commit-lock-file"
        "--print-build-logs"
        "--refresh"
      ];
      dates = "05:00";
      randomizedDelaySec = "45min";
      allowReboot = false;
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfree;

    environment.defaultPackages = lib.mkForce [ ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit
          inputs
          outputs
          dotsPath
          myUtils
          ;
      };
    };
  };
}
