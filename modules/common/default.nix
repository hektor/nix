let
  flakePath = "/home/h/nix";
in
{
  inputs,
  outputs,
  dotsPath,
  ...
}:

{
  imports = [
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
    flake = flakePath;
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
}
