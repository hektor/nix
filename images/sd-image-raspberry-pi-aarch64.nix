# see <https://nixos.wiki/wiki/NixOS_on_ARM#Build_your_own_image_natively>
# see <https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_3>
# ```
# nix build .#images.sd-image-raspberry-pi-aarch64
# nix-shell -p zstd --run "zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync"
# ```

{ pkgs, ... }:

let
  username = "h";
in
{
  imports = [
    ../modules/ssh/hardened-openssh.nix
  ];

  ssh.username = username;
  ssh.authorizedHosts = [
    "andromache"
    "astyanax"
  ];

  boot.kernelParams = [
    "console=ttyS1,115200n8"
  ];

  boot.kernelModules = [
    "bcm2835-v4l2"
  ];

  hardware.enableRedistributableFirmware = true;

  services.pulseaudio.enable = true;

  networking.wireless.enable = true;

  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users = {
    root.initialPassword = "nixos";
    ${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "nixos";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    harden = true;
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  system.stateVersion = "26.05";
}
