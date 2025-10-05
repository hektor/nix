{ ... }:

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

  disko = {
    devices.disk.main.device = "/dev/vda";
    devices.disk.main.imageName = "nixos-vm";
    devices.disk.main.imageSize = "32G";
  };

  virtualisation.vmVariantWithDisko = {
    virtualisation = {
      cores = 8;
      memorySize = 16384;
      qemu.options = [
        "-enable-kvm"
        "-cpu host"
        "-nographic"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.h = ./home.nix;
  };

  services.qemuGuest.enable = true;
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
