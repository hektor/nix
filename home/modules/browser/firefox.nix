{ config, inputs, lib, pkgs, ... }:

let
  bookmarks = import ./bookmarks.nix;
in

{
  config = lib.mkIf (config.browser.primary == "firefox" || config.browser.secondary == "firefox") {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        tridactyl-native
      ];
      profiles = {
        default = {
          settings = {
            "signon.rememberSignons" = false;
            "findbar.highlightAll" = true;
            "extensions.autoDisableScopes" = 0;
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
          bookmarks = {
            force = true;
            settings = [
              {
                toolbar = true;
                bookmarks = [
                  bookmarks.nixos
                ];
              }
            ];
          };
        };
      };
      policies = {
        DefaultDownloadDirectory = "\${home}/dl";
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
  };
}
