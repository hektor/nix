{ lib, config, ... }:

{
  config = lib.mkIf (config.host.role == "embedded") {
    system.autoUpgrade.enable = false;
    nix.settings.max-jobs = 0;

    memory.zram.enable = true;
    zramSwap.memoryPercent = 100;

    services.journald.settings.Journal.SystemMaxUse = "100M";
  };
}
