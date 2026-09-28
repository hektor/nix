{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  betterBibtex = pkgs.fetchzip (finalAttrs: {
    pname = "zotero-better-bibtex";
    version = "9.0.64";
    url = "https://github.com/retorquere/zotero-better-bibtex/releases/download/v${finalAttrs.version}/zotero-better-bibtex-${finalAttrs.version}.xpi";
    hash = "sha256-eu/lkWdW/wbehBjk/5ERnKxBob6yaoS4qsh75RaQx5A=";
    extension = "zip";
    stripRoot = false;
  });

  hasBrowser =
    name:
    lib.elem name [
      config.browser.primary
      config.browser.secondary
    ];

  zoteroConnector =
    inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}.zotero-connector;
  zoteroAddonId = "zotero@chnm.gmu.edu";

  connectorExtension = {
    profiles.default.extensions.packages = [ zoteroConnector ];
    policies.ExtensionSettings.${zoteroAddonId}.default_area = "navbar";
  };
in
{
  options.reference-manager.enable = lib.mkEnableOption "reference manager (Zotero)";

  config = lib.mkIf config.reference-manager.enable {
    home = {
      packages = [ pkgs.zotero ];
      file = {
        ".zotero/bbt.json".source = ./bbt.json;
        ".zotero/zotero/profiles.ini".text = lib.generators.toINI { } {
          General = {
            StartWithLastProfile = 1;
            Version = 2;
          };
          Profile0 = {
            Name = "default";
            IsRelative = 1;
            Path = "default";
            Default = 1;
          };
        };

        ".zotero/zotero/default/extensions/better-bibtex@iris-advies.com".source = betterBibtex;
        ".zotero/zotero/default/user.js".text = ''
          user_pref("extensions.startupScanScopes", 1);
          user_pref("extensions.autoDisableScopes", 14);
        '';
      };
    };

    programs.firefox = lib.mkIf (hasBrowser "firefox") connectorExtension;
    programs.librewolf = lib.mkIf (hasBrowser "librewolf") connectorExtension;
  };
}
