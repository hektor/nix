{ lib, config, ... }:

{
  options.my.users.enable = lib.mkEnableOption "user account";

  config = lib.mkIf config.my.users.enable {
    users.users.${config.host.username} = {
      isNormalUser = true;
      description = config.host.username;
      extraGroups = [
        "wheel"
        "render"
        "video"
      ];
      initialPassword = "h";
    };
  };
}
