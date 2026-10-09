{ lib, config, ... }:

let
  cfg = config.graphics;
  cardCount = lib.count lib.id [
    cfg.intel.enable
    cfg.nvidia.enable
  ];
in
{
  imports = [
    ./intel-arc-140t.nix
    ./intel-uhd-770.nix
    ./nvidia.nix
  ];

  options.graphics = {
    enable = lib.mkEnableOption "graphics";
    intel = {
      enable = lib.mkEnableOption "Intel graphics";
      model = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "arc-140t"
            "uhd-770"
          ]
        );
        default = null;
      };
    };
    nvidia.enable = lib.mkEnableOption "NVIDIA graphics";
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.enable && cardCount != 1);
        message = "'graphics.enable' requires one and only one graphics card";
      }
      {
        assertion = !(cardCount > 0 && !cfg.enable);
        message = "'graphics.*.enable' require 'graphics.enable'";
      }
      {
        assertion = !(cfg.intel.enable && cfg.intel.model == null);
        message = "'graphics.intel.enable' requires 'graphics.intel.model'";
      }
      {
        assertion = !(cfg.intel.model != null && !cfg.intel.enable);
        message = "'graphics.intel.model' requires 'graphics.intel.enable'";
      }
    ];

    hardware.graphics.enable = lib.mkIf cfg.enable true;
  };
}
