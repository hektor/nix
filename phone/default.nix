{
  pkgs,
  ...
}:

{
  environment.packages = with pkgs; [
    neovim
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "Europe/Brussels";

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };
}
