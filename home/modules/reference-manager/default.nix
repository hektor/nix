{ config, lib, ... }:

{
  options.reference-manager.enable = lib.mkOption { default = false; };

  config = lib.mkIf config.reference-manager.enable {
    programs.papis = {
      enable = true;
      libraries.papers = {
        isDefault = true;
        settings.dir = "${config.readings.path}/papis";
      };
      settings = {
        unique-document-keys = ''["ref"]'';
        bibtex-ignore-keys = ''["abstract", "note", "csl_type", "collections", "tags", "files"]'';
        add-folder-name = "{doc[ref]}";
      };
    };
  };
}
