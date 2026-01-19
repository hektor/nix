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
    ../../modules/dconf.nix
    ../../modules/git.nix
    ../../modules/k9s.nix
    ../../modules/keepassxc.nix
    ../../modules/kitty.nix
    ../../modules/browser
    ../../modules/shell
    ../../modules/taskwarrior.nix
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
    };

    templates."taskrc.d/sync" = {
      content = ''
        sync.server.url=${config.sops.placeholder.taskwarrior_sync_server_url}
        sync.server.client_id=${config.sops.placeholder.taskwarrior_sync_server_client_id}
        sync.encryption_secret=${config.sops.placeholder.taskwarrior_sync_encryption_secret}
      '';
    };
  };

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  browser.primary = "firefox";
  browser.secondary = "chromium";

  shell.bash.enable = true;
  starship.enable = true;

  programs = {
    gh.enable = true;
    kubecolor.enable = true;
  };

  home.packages = import ./packages.nix {
    inherit inputs;
    inherit config;
    inherit pkgs;
  };
}
