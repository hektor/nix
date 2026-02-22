{
  nixpkgs.allowedUnfree = [
    "steam"
    "steam-unwrapped"
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };
}
