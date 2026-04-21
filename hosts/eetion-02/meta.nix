{
  system = "aarch64-linux";
  deployment = {
    tags = [ "arm" ];
    targetHost = "eetion-02";
    targetUser = "h";
  };
  role = "embedded";
}
