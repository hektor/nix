{
  inputs,
  config,
  pkgs,
  ...
}:

let
  username = "hektor";
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules
    ../../modules/ai-tools
    ../../modules/anki.nix
    ../../modules/browser
    ../../modules/bruno
    ../../modules/cloud
    ../../modules/comms
    ../../modules/database
    ../../modules/dconf
    ../../modules/desktop/niri
    ../../modules/direnv
    ../../modules/docker
    ../../modules/git
    ../../modules/go
    ../../modules/infra
    ../../modules/k8s
    ../../modules/k8s/k9s.nix
    ../../modules/keepassxc
    ../../modules/kitty.nix
    ../../modules/music
    ../../modules/nodejs.nix
    ../../modules/nvim
    ../../modules/pandoc
    ../../modules/secrets
    ../../modules/shell
    ../../modules/stylix
    ../../modules/taskwarrior
    ../../modules/terminal
    ../../modules/vscode.nix
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${inputs.nix-secrets}/secrets.yaml";

    secrets = {
      taskwarrior_sync_server_url = { };
      taskwarrior_sync_server_client_id = { };
      taskwarrior_sync_encryption_secret = { };
      anki_sync_user = { };
      anki_sync_key = { };
      opencode_api_key = { };
    };

    templates = {
      "taskrc.d/sync" = {
        content = ''
          sync.server.url=${config.sops.placeholder.taskwarrior_sync_server_url}
          sync.server.client_id=${config.sops.placeholder.taskwarrior_sync_server_client_id}
          sync.encryption_secret=${config.sops.placeholder.taskwarrior_sync_encryption_secret}
        '';
      };

      "opencode/auth.json" = {
        path = "${config.home.homeDirectory}/.local/share/opencode/auth.json";
        content = ''
          {
            "zai-coding-plan": {
              "type": "api",
              "key": "${config.sops.placeholder.opencode_api_key}"
            }
          }
        '';
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  xdg.systemDirs.config = [ "/etc/xdg" ];

  home = {
    stateVersion = "25.05";
    inherit username;
    homeDirectory = "/home/${username}";
  };

  targets.genericLinux.nixGL = {
    inherit (inputs.nixgl) packages;
    defaultWrapper = "mesa";
  };

  browser.primary = "firefox";
  browser.secondary = "chromium";
  cloud.azure.enable = true;
  comms.signal.enable = true;
  comms.teams.enable = true;
  ai-tools = {
    claude-code.enable = true;
    opencode.enable = true;
  };
  database.mssql.enable = true;
  database.postgresql.enable = true;
  github.enable = true;
  gitlab.enable = true;
  secrets.vault.enable = true;

  programs = {
    gh.enable = true;
    kubecolor.enable = true;
  };

  home.packages =
    import ./packages.nix {
      inherit inputs;
      inherit config;
      inherit pkgs;
    }
    ++ import ../packages.nix {
      inherit inputs;
      inherit config;
      inherit pkgs;
    };
}
