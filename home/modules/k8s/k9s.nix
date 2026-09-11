{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.k8s.k9s.enable {
    programs.k9s = {
      enable = true;
      settings.k9s = {
        ui = {
          logoless = true;
          reactive = true;
        };
      };
      views."v1/pods".sortColumn = "MEM:desc";
    };
  };
}
