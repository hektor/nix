{ lib, ... }:

{
  options.cloud = {
    azure = {
      enable = lib.mkEnableOption "Azure CLI";
    };
    hetzner = {
      enable = lib.mkEnableOption "Hetzner CLI";
    };
  };

  imports = [
    ./azure.nix
    ./hetzner.nix
  ];
}
