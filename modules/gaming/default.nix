{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.allowedUnfree = [
    "steam"
    "steam-unwrapped"
    "lutris"
  ];

  hardware.graphics = {
    enable32Bit = true;
    extraPackages = with pkgs; [
      dxvk
      vkd3d-proton
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    lutris
    mangohud
  ];

  home-manager.users.${config.host.username} = {
    xdg.configFile."lutris/system.yml".text = lib.generators.toJSON { } {
      system.game_path = "/home/${config.host.username}/games";
    };
  };

  security.pam.loginLimits = [
    {
      domain = config.host.username;
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];
}
