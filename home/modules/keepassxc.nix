{ pkgs, ... }:

{
  programs.keepassxc = {
    enable = true;
    settings = {
      Browser.Enabled = true;
    };
  };
  # programs.firefox.nativeMessagingHosts = [ pkgs.keepassxc ]; # FIXME: Resolve 'Access error for config file $HOME/.config/keepassxc/keepassxc.ini' error
}
