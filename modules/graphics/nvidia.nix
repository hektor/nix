{ lib, config, ... }:

{
  config = lib.mkIf (config.graphics.enable && config.graphics.nvidia.enable) {
    nixpkgs.allowedUnfree = [
      "nvidia-x11"
      "nvidia-persistenced"
      "nvidia-settings"
    ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
