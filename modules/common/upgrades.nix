{ lib, ... }:

{
  config.system.autoUpgrade = {
    enable = lib.mkDefault true;
    flags = [
      "--recreate-lock-file"
      "--commit-lock-file"
      "--print-build-logs"
      "--refresh"
    ];
    dates = "05:00";
    randomizedDelaySec = "45min";
    allowReboot = false;
  };
}
