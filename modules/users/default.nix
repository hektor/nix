{ config, ... }:

{
  users.users.${config.host.username} = {
    isNormalUser = true;
    description = config.host.username;
    extraGroups = [ "wheel" ];
    initialPassword = "h";
  };
}
