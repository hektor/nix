{
  inputs,
  outputs,
  dotsPath,
  config,
  ...
}:

let
  inherit (inputs.nixpkgs) lib;
in
{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  options.nixpkgs.allowedUnfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    system.stateVersion = "25.05";

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfree;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs outputs dotsPath;
      };
    };

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
  };
}
