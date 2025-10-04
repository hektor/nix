{ pkgs, ... }:

{
  users.users.h = {
    isNormalUser = true;
    description = "h";
    extraGroups = [ "wheel" ];
  };
}
