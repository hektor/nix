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

  ai-tools = {
    claude-code.enable = true;
    tirith.enable = true;
    opencode.enable = true;
  };
  anki.enable = true;
  browser = {
    enable = true;
    primary = "firefox";
    secondary = "chromium";
  };
  bruno.enable = true;
  cloud.azure.enable = true;
  comms.signal.enable = true;
  comms.teams.enable = true;
  database = {
    mssql.enable = true;
    postgresql.enable = true;
    redis.enable = true;
  };
  desktop.niri.enable = true;
  devenv.enable = true;
  direnv.enable = true;
  docker.enable = true;
  git = {
    enable = true;
    github.enable = true;
    gitlab.enable = true;
  };
  go.enable = true;
  k8s.enable = true;
  keepassxc.enable = true;
  music.enable = true;
  my.dconf.enable = true;
  my.stylix.enable = true;
  nvim.enable = true;
  pandoc.enable = true;
  shell.enable = true;
  taskwarrior.enable = true;
  terminal.enable = true;
  infra.enable = true;
  nodejs.enable = true;
  secrets.enable = true;
  secrets.vault.enable = true;
  ticketing.enable = true;
  vscode.enable = true;

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "weekly";
  };

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
