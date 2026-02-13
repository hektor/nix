{ config, lib, ... }:

{
  options.nixgl.wrap = lib.mkOption {
    type = lib.types.functionTo lib.types.package;
    default = if config.lib ? nixGL then config.lib.nixGL.wrap else lib.id;
    readOnly = true;
  };
}
