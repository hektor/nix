# see <https://nixos.wiki/wiki/NixOS_on_ARM#Build_your_own_image_natively>
# see <https://nixos.wiki/wiki/NixOS_on_ARM/Orange_Pi_Zero2_H616>
# ```
# nix build .#images.sd-image-aarch64
# nix-shell -p zstd --run "zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync"
# # add u-boot bootloader (e.g. for Orange Pi Zero2 H616)
# sudo dd if=~/dl/u-boot-sunxi-with-spl.bin of=/dev/sdX bs=1024 seek=8
# ```

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

  # sdImage.postBuildCommands =
  #   let
  #     bootloaderPackage = pkgs.ubootOrangePiZero2;
  #     bootloaderSubpath = "/u-boot-sunxi-with-spl.bin";
  #   in
  #   ''
  #     dd if=${bootloaderPackage}${bootloaderSubpath} of=$img \
  #       bs=8 seek=1024 \
  #       conv=notrunc
  #   '';

  system.stateVersion = "26.05";
}
