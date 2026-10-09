{
  lib,
  config,
  pkgs,
  ...
}:

{
  config =
    lib.mkIf
      (
        config.graphics.enable && config.graphics.intel.enable && config.graphics.intel.model == "arc-140t"
      )
      {
        boot.initrd.kernelModules = [ "i915" ];
        hardware.graphics = {
          enable32Bit = true;
          extraPackages = with pkgs; [
            intel-compute-runtime
            intel-media-driver
            vpl-gpu-rt
          ];
          extraPackages32 = with pkgs; [ driversi686Linux.intel-media-driver ];
        };
        environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
      };
}
