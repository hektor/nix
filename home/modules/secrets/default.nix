{
  pkgs,
  ...
}:
{
  imports = [ ./vault.nix ];

  home.packages = with pkgs; [
    sops
    age
  ];
}
