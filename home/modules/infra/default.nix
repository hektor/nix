{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      opentofu
      upbound
    ];
  };
}
