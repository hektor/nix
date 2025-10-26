{
  pkgs,
  config,
  inputs,
  ...
}:

{
  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  home.username = "hektor";
  home.homeDirectory = "/home/hektor";
  home.stateVersion = "25.05";

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      tridactyl-native
    ];
    policies = {
      DefaultDownloadDirectory = "\${home}/dl";
    };
    profiles = {
      work = {
        settings = {
          "signon.rememberSignons" = false;
          "findbar.highlightAll" = true;
          "extensions.autoDisableScopes" = 0; # Enable extensions by default <https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions.packages>
        };
        extensions = {
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            duckduckgo-privacy-essentials
            istilldontcareaboutcookies
            libredirect
            keepassxc-browser
            react-devtools
            sponsorblock
            tridactyl
            ublock-origin
          ];
        };
      };
    };
    policies = {
      ExtensionSettings = {
        "jid1-ZAdIEUB7XOzOJw@jetpack" = {
          default_area = "navbar";
          private_browsing = true;
        };
        "idcac-pub@guus.ninja" = {
          default_area = "navbar";
          private_browsing = true;
        };
        "7esoorv3@alefvanoon.anonaddy.me" = {
          default_area = "navbar";
        };
        "keepassxc-browser@keepassxc.org" = {
          default_area = "navbar";
          private_browsing = true;
        };
        "@react-devtools" = {
          default_area = "navbar";
          private_browsing = true;
        };
        "sponsorBlocker@ajay.app" = {
          default_area = "navbar";
          private_browsing = true;
        };
        "tridactyl.vim@cmcaine.co.uk".settings = {
          private_browsing = true;
        };
        "uBlock0@raymondhill.net".settings = {
          default_area = "navbar";
          private_browsing = true;
        };
      };
    };
  };
  home.packages = import ./packages.nix {
    inherit pkgs;
    inherit config;
  };
}
