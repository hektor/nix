{
  system = "x86_64-linux";
  deployment = {
    tags = [ "cloud" ];
    targetHost = "server.hektormisplon.xyz";
    targetUser = "username";
  };
  role = "server";
}
