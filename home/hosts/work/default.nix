{
  inputs,
  config,
  pkgs,
  ...
}:

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
    username = "hektor";
    homeDirectory = "/home/${config.home.username}";
  };

  targets.genericLinux.nixGL = {
    inherit (inputs.nixgl) packages;
    defaultWrapper = "mesa";
  };

  desktop.niri.enable = true;
  browser = {
    enable = true;
    primary = "firefox";
    secondary = "chromium";
  };
  devenv.enable = true;
  music.enable = true;
  terminal.enable = true;
  keepassxc.enable = true;
  direnv.enable = true;
  nvim.enable = true;
  my.dconf.enable = true;
  pandoc.enable = true;
  cloud.azure.enable = true;
  comms.signal.enable = true;
  comms.teams.enable = true;
  ai-tools = {
    claude-code.enable = true;
    tirith.enable = true;
    opencode.enable = true;
  };
  database = {
    mssql.enable = true;
    postgresql.enable = true;
    redis.enable = true;
  };
  anki.enable = true;
  taskwarrior.enable = true;
  k8s.enable = true;
  shell.enable = true;
  my.stylix.enable = true;
  git = {
    enable = true;
    github.enable = true;
    gitlab.enable = true;
  };
  secrets.enable = true;
  secrets.vault.enable = true;
  bruno.enable = true;
  docker.enable = true;
  infra.enable = true;
  go.enable = true;
  nodejs.enable = true;
  ticketing.enable = true;
  vscode.enable = true;

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
