{
  system = "x86_64-linux";
  tags = [ "lab" ];
  deploy.autoRollback = true;
  host = {
    role = "server";
    username = "h";
  };
}
