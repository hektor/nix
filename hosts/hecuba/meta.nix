{
  system = "x86_64-linux";
  role = "server";
  tags = [ "lab" ];
  deploy.autoRollback = true;
  host = {
    username = "username";
  };
}
