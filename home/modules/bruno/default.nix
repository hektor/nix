{ config, pkgs, ... }:

{
  config = {
    home.packages = [ (config.nixgl.wrap (config.wrapApp pkgs.bruno "--no-sandbox")) ];
  };
}
