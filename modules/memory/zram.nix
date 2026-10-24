{ config, lib, ... }:

{
  config = lib.mkIf config.memory.zram.enable {
    zramSwap.enable = true;
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 180;
      "vm.page-cluster" = lib.mkDefault 0;
    };
  };
}
