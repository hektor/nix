{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hard.nix
    ./host.nix
    ./disk.nix
    ../../modules
  ];

  home-manager.users.${config.host.username} = import ../../home/hosts/vm;

  "ai-tools".enable = true;
  anki.enable = true;
  audio.enable = true;
  bootloader.enable = true;
  desktop.x.enable = true;
  git.enable = true;
  keyboard.enable = true;
  localization.enable = true;
  my = {
    fonts.enable = true;
    stylix.enable = true;
    users.enable = true;
  };
  networking.enable = true;
  secrets.enable = true;
  ssh.enable = true;
  storage.enable = true;
  taskwarrior.enable = true;

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
