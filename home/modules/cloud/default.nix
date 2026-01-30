{ lib, ... }:

{
  options.cloud = {
    azure = {
      enable = lib.mkEnableOption "azure CLI";
    };
    hetzner = {
      enable = lib.mkEnableOption "hetzner CLI";
    };
  };

  imports = [
    ./azure.nix
    ./hetzner.nix
  ];
}
