{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
  ];
}
