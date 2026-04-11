{
  pkgs,
  ...
}:
{
  imports = [ ./vault.nix ];

  home.packages = with pkgs; [
    age
    age-plugin-yubikey # TODO: only needed when using Yubikey
    sops
  ];
}
