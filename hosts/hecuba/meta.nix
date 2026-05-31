{
  system = "x86_64-linux";
  deployment = {
    tags = [ "cloud" ];
    targetHost = "hecuba";
    targetUser = "username";
  };
  role = "server";
}
