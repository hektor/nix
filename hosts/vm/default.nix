{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hard.nix
    ./host.nix
    ./disk.nix
    ../../modules/common
    ../../modules/anki
    ../../modules/audio
    ../../modules/boot/bootloader.nix
    ../../modules/fonts
    ../../modules/git
    ../../modules/keyboard
    ../../modules/localization
    ../../modules/networking
    ../../modules/ai-tools
    ../../modules/ssh
    ../../modules/storage
    ../../modules/stylix
    ../../modules/secrets
    ../../modules/taskwarrior
    ../../modules/users
    ../../modules/x
  ];

  home-manager.users.${config.host.username} = import ../../home/hosts/vm {
    inherit inputs config pkgs;
  };

  ssh.username = config.host.username;

  secrets.username = config.host.username;

  disko = {
    devices.disk.main = {
      device = "/dev/vda";
      imageName = "nixos-vm";
      imageSize = "32G";
    };
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

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };
}
