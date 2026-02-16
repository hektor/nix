{ lib, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      border-color = lib.mkForce "#bbbbbb";
    };
  };
}
