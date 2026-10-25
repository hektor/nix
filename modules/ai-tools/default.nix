{ lib, config, ... }:

let
  inherit (config.host) username;
  inherit (config.secrets) owner;
in
{
  options."ai-tools".enable = lib.mkEnableOption "AI tools";

  config = lib.mkIf config."ai-tools".enable {
    nixpkgs.allowedUnfree = [
      "claude-code"
      "rtk"
    ];
    secrets.opencode = [ "api-key" ];

    sops.templates."opencode/auth.json" = {
      inherit owner;
      path = "/home/${username}/.local/share/opencode/auth.json";
      content = ''
        {
          "zai-coding-plan": {
            "type": "api",
            "key": "${config.sops.placeholder."opencode/api-key"}"
          }
        }
      '';
    };
  };
}
