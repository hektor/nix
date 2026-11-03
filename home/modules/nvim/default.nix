{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let
  themes = import "${inputs.nvim}/themes.nix" pkgs;
  plugins = themes.${config.nvim.colorscheme};
in
{
  imports = [ inputs.nvim.homeModules.default ];

  options.nvim = {
    colorscheme = lib.mkOption {
      type = lib.types.enum (lib.attrNames themes);
      default = "zenwritten";
    };
    typescriptServer = lib.mkOption {
      default = "ts_ls";
      type = lib.types.enum [
        "ts_ls"
        "vtsls"
      ];
    };
    languages = lib.mapAttrs (
      _: language:
      lib.mkOption {
        default = language.enable;
        type = lib.types.bool;
      }
    ) (import "${inputs.nvim}/languages.nix" { inherit pkgs; });
  };

  config = lib.mkIf config.nvim.enable {
    nvim.languages = {
      docker = lib.mkDefault config.docker.enable;
      go = lib.mkDefault config.go.enable;
      helm = lib.mkDefault config.k8s.helm.enable;
      openscad = lib.mkDefault config.modules."3d".modeling.openscad.enable;
      typescript = lib.mkDefault config.nodejs.enable;
    };

    nvim.packageDefinitions.merge.nvim = _: {
      categories = {
        colorscheme = config.nvim.colorscheme;
        github = config.git.github.enable;
        inherit (config.nvim) languages typescriptServer;
      };
    };

    home = {
      sessionVariables = {
        EDITOR = "nvim";
        SUDO_EDITOR = "nvim";
        SYSTEMD_EDITOR = "nvim";

        PAGER = "nvimpager";
        MANWIDTH = "80";
      };
      packages = with pkgs; [ nvimpager ];
    };

    xdg.configFile."nvimpager/init.lua".text = ''
      vim.opt.clipboard = "unnamedplus"
      vim.opt.background = "dark"
      vim.g.zenwritten_compat = 1
      ${lib.concatMapStringsSep "\n" (plugin: ''vim.opt.runtimepath:append("${plugin}")'') plugins}
      vim.cmd.colorscheme("${config.nvim.colorscheme}")
    '';
  };
}
