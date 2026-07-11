{ inputs, lib, ... }:

{
  config.nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
    optimise = {
      automatic = true;
      dates = [ "05:00" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.trusted-public-keys = [
      "nix-signing-key:M6ouQRFl/bZ5QQrceQUyar6P7o8qg4wwVkxD1SSLL2k="
    ];
  };
}
