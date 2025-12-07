{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    plugins-shipwright-nvim = {
      url = "github:rktjmp/shipwright.nvim";
      flake = false;
    };
    plugins-crazy-node-movement = {
      url = "github:theHamsta/crazy-node-movement";
      flake = false;
    };
    plugins-beancount-nvim = {
      url = "github:polarmutex/beancount.nvim";
      flake = false;
    };
    plugins-tailwind-fold-nvim = {
      url = "github:razak17/tailwind-fold.nvim";
      flake = false;
    };
    plugins-nvimkit-nvim = {
      url = "github:jamesblckwell/nvimkit.nvim";
      flake = false;
    };
    plugins-mcphub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
      flake = false;
    };
    plugins-helm-ls-nvim = {
      url = "github:qvalentin/helm-ls.nvim";
      flake = false;
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = { };

      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      categoryDefinitions =
        {
          pkgs,
          ...
        }:
        {
          lspsAndRuntimeDeps = with pkgs; {
            general = [
              black
              clang
              clang-tools
              gawk
              gdtoolkit_4
              isort
              tree-sitter
              ormolu
              nodePackages.prettier
              nixd
              nixfmt
              prettierd
              shellcheck-minimal
              stylua
              vscode-langservers-extracted
            ];
          };

          startupPlugins = {
            general = with pkgs.vimPlugins; [
              ## plug
              vim-plug
              vim-sandwich
              context_filetype-vim
              editorconfig-vim
              vim-snippets
              unicode-vim
              vim-css-color
              quarto-nvim
              vimtex
              wiki-vim
              vim-pandoc
              vim-pandoc-syntax
              # TODO: ferrine/md-img-paste.vim
              # TODO: supercollider/scvim
              # TODO: tidalcycles/vim-tidal
              vim-glsl
              # TODO: timtro/glslView-nvim
              # TODO: sirtaj/vim-openscad
              jupytext-nvim
              vim-openscad
              ## paq
              eyeliner-nvim
              fzf-lua
              ltex_extra-nvim
              nvim-lspconfig
              lsp_lines-nvim
              lsp-progress-nvim
              neodev-nvim
              SchemaStore-nvim
              nvim-lint
              conform-nvim
              luasnip
              cmp_luasnip
              nvim-cmp
              cmp-nvim-lsp
              cmp-buffer
              cmp-path
              plenary-nvim
              nui-nvim
              trouble-nvim
              pkgs.neovimPlugins.shipwright-nvim
              lush-nvim
              zenbones-nvim
              pkgs.neovimPlugins.crazy-node-movement
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
              # nvim-treesitter-context
              nvim-ts-context-commentstring
              treesj
              sniprun
              gitsigns-nvim
              nvim-highlight-colors
              pkgs.neovimPlugins.tailwind-fold-nvim
              auto-session
              nvim-dbee
              image-nvim
              pkgs.neovimPlugins.beancount-nvim
              pkgs.neovimPlugins.nvimkit-nvim
              codecompanion-nvim
              pkgs.neovimPlugins.mcphub-nvim
              copilot-lua
              copilot-cmp
              pkgs.neovimPlugins.helm-ls-nvim
              pkgs.vimPlugins.kitty-scrollback-nvim
              rustaceanvim
            ];
          };

          optionalPlugins = {
            general = with pkgs.vimPlugins; [
            ];
          };

          sharedLibraries = {
            general = [ ];
          };

          environmentVariables = { };
        };

      packageDefinitions = {
        nvim =
          { ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [ "vim" ];
            };
            categories = {
              general = true;
            };
          };
      };
      defaultPackageName = "nvim";
    in

    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        };

      }
    )
    // (
      let
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {

        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );

}
