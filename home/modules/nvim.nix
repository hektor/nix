{ inputs, ... }:

{
  config = {
    home.packages = [
      inputs.nvim.packages.${builtins.currentSystem}.nvim
    ];
  };
}
