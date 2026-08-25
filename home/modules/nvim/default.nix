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

  options.nvim.colorscheme = lib.mkOption {
    type = lib.types.enum (lib.attrNames themes);
    default = "zenwritten";
  };

  config = lib.mkIf config.nvim.enable {
    nvim.packageDefinitions.merge.nvim = _: {
      categories.colorscheme = config.nvim.colorscheme;
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
