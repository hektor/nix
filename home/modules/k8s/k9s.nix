{
  programs.k9s = {
    enable = true;
    settings.k9s = {
      ui = {
        logoless = true;
        reactive = true;
      };
    };
  };
}
