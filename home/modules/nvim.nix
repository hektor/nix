{ pkgs, inputs, ... }:

{
  config = {
    home.packages = [
      inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];
  };
}
