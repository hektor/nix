{ inputs, pkgs, ... }:

{
  config = {
    home.packages = [
      inputs.nvim.packages.${pkgs.system}.nvim
    ];
  };
}
