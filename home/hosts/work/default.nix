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
    ../../modules/anki
    ../../modules/browser
    ../../modules/bruno
    ../../modules/cloud
    ../../modules/comms
    ../../modules/database
    ../../modules/dconf
    ../../modules/desktop/niri
    ../../modules/devenv
    ../../modules/direnv
    ../../modules/docker
    ../../modules/git
    ../../modules/go
    ../../modules/infra
    ../../modules/k8s
    ../../modules/k8s/k9s.nix
    ../../modules/keepassxc
    ../../modules/music
    ../../modules/nodejs
    ../../modules/nvim
    ../../modules/pandoc
    ../../modules/secrets
    ../../modules/shell
    ../../modules/stylix
    ../../modules/taskwarrior
    ../../modules/ticketing
    ../../modules/terminal
    ../../modules/vscode
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  nixpkgs.config.allowUnfree = true;

  xdg = {
    systemDirs.config = [ "/etc/xdg" ];
    userDirs = {
      createDirectories = false;
      download = "${config.home.homeDirectory}/dl";
    };
  };

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
    tirith.enable = true;
    opencode.enable = true;
  };
  database.mssql.enable = true;
  database.postgresql.enable = true;
  git.github.enable = true;
  git.gitlab.enable = true;
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
