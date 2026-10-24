{ config, lib, ... }:

{
  config = lib.mkIf config.memory.oom.enable {
    systemd.oomd.enableUserSlices = lib.mkDefault true;
  };
}
