{ pkgs, ... }:

{
  system.stateVersion = "25.05";

  imports = [
    ./hard.nix
    ./disk.nix
    ../../modules/bootloader.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/audio.nix
    ../../modules/printing.nix
    ../../modules/localization.nix
    ../../modules/x.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  disko.devices.disk.main.device = "/dev/vda";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.h = ./home.nix;
  };

  programs.git.enable = true;
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    kitty
  ];

  services.spice-vdagentd.enable = true;
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      ## hardening
      PermitRootLogin = "no";
      MaxAuthTries = 3;
      LoginGraceTime = "1m";
      PasswordAuthentication = false;
      PermitEmptyPasswords = false;
      ChallengeResponseAuthentication = false;
      KerberosAuthentication = false;
      GSSAPIAuthentication = false;
      X11Forwarding = false;
      PermitUserEnvironment = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = false;
      PermitTunnel = false;
      ## sshd_config defaults on Arch Linux
      KbdInteractiveAuthentication = false;
      UsePAM = true;
      PrintMotd = false;
    };
  };
}
