{ pkgs, ... }:

{
  users.users.h = {
    isNormalUser = true;
    description = "h";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
}
