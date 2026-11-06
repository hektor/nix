{
  config,
  lib,
  pkgs,
  lib',
  osConfig ? null,
  inputs ? null,
  ...
}:

let
  sops = lib'.sopsAvailability config osConfig;
  standalone = osConfig == null;
in
{
  config = lib.mkIf config.ai-tools.opencode.enable (
    lib.optionalAttrs standalone {
      sops = {
        secrets = lib'.mkSopsSecrets "${toString inputs.nix-secrets}/secrets" null {
          opencode = [ "api-key" ];
        };
        templates."opencode/auth.json" = {
          path = "${config.home.homeDirectory}/.local/share/opencode/auth.json";
          content = builtins.toJSON {
            zai-coding-plan = {
              type = "api";
              key = config.sops.placeholder."opencode/api-key";
            };
          };
        };
      };
    }
    // {
      warnings =
        lib.optional (!sops.available)
          "opencode is enabled, but sops templates are not available. the opencode API key will not be configured.";

      home.packages = [ pkgs.opencode ];
      home.file.".config/opencode/opencode.json".text = builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        permission = {
          external_directory = {
            "/run/secrets/" = "deny";
            "~/.config/sops/age/keys.txt" = "deny";
            "~/.ssh/id_rsa" = "deny";
            "~/.ssh/id_ed25519" = "deny";
            "~/.ssh/id_ecdsa" = "deny";
            "~/.ssh/id_dsa" = "deny";
            "/etc/ssh/ssh_host_rsa_key" = "deny";
            "/etc/ssh/ssh_host_ed25519_key" = "deny";
            "/etc/ssh/ssh_host_ecdsa_key" = "deny";
            "/etc/ssh/ssh_host_dsa_key" = "deny";
          };
          command = {
            sops = "deny";
          };
        };
        plugin = [ "@mohak34/opencode-notifier@latest" ];
      };
    }
  );
}
