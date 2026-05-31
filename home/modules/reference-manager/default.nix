{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.reference-manager;

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

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.zotero ];

    programs.firefox = lib.mkIf (hasBrowser "firefox") connectorExtension;
    programs.librewolf = lib.mkIf (hasBrowser "librewolf") connectorExtension;
  };
}
