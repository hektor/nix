{
  config,
  lib,
  ...
}:

let
  cfg = config.git;
  identities = [
    "personal"
    "work"
  ];

  emailTemplate = key: ".gitconfig.${key}.email";
  emailInclude =
    key:
    lib.optionalAttrs (config.secrets.templatePath ? ${emailTemplate key}) {
      include.path = config.secrets.templatePath.${emailTemplate key};
    };

  workSettings = emailInclude "work" // {
    core.longpaths = true;
    user = {
      name = "Hektor Misplon";
      username = "hektor.misplon";
      signingKey = "1C88BE828184CEE6";
    };
    commit.gpgSign = false;
  };
in
{
  options.git = {
    enable = lib.mkEnableOption "git";

    gitea = {
      enable = lib.mkEnableOption "Gitea CLI";
    };
    github = {
      enable = lib.mkEnableOption "Github CLI";
    };
    gitlab = {
      enable = lib.mkEnableOption "Gitlab CLI";
    };
  };

  imports = [
    ./gitea.nix
    ./github.nix
    ./gitlab.nix
  ];

  config = lib.mkIf cfg.enable {
    secrets.files.email = identities;

    secrets.templates = lib.genAttrs' identities (
      key:
      lib.nameValuePair (emailTemplate key) {
        content = ''
          [user]
            email = ${config.sops.placeholder."email/${key}"}
        '';
      }
    );

    warnings = lib.optional (
      !config.nvim.enable
    ) "'git.enable' is enabled without 'nvim.enable' (not using 'nvimdiff')";

    xdg.configFile."git/ignore".source = ./global.gitignore;

    programs.git = {
      enable = true;
      settings = lib.mkMerge [
        {
          user = {
            name = "Hektor Misplon";
            username = "hektor";
            signingKey = "AEB98353B8D72E465C4236435151AF79E723F21C";
          };
          alias = {
            d = "diff";
            ds = "diff --staged";
            a = "add";
            ap = "add -p";
            c = "commit";
            cm = "commit -m";
            cam = "commit --amend";
            l = ''log --pretty=format:(%an)\ \ %h\ \ %ad\ \ %s --date=short'';
            s = "status --short";
            sv = "status --verbose";
            co = "checkout";
            cob = "checkout -b";
            pullr = "pull --rebase --autostash";
            pushf = "push --force-with-lease";
            al = "!git config -l | grep alias | cut -c 7-";
            alf = "!git config -l | grep alias | cut -c 7- | fzf";
            "al-" =
              ''!git config --local --unset $(git config -l | grep alias | cut --delimiter="=" --fields=1 | fzf)'';
            rs = "restore --staged";
            rb = "rebase";
            rbi = "rebase -i";
            wt = "worktree";
            wtc = ''config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"'';
          };
          color = {
            ui = "auto";
            diff = {
              meta = "yellow bold";
              commit = "green bold";
              frag = "magenta bold";
              old = "red bold";
              new = "green bold";
              whitespace = "red reverse";
            };
            "diff-highlight" = {
              oldNormal = "red bold";
              oldHighlight = "red bold 52";
              newNormal = "green bold";
              newHighlight = "green bold 22";
            };
            branch = {
              current = "normal bold";
              local = "normal";
              remote = "normal italic";
            };
            status = {
              added = "green";
              changed = "yellow";
              untracked = "normal italic";
            };
          };
          credential.helper = "cache --timeout=3600";
          init.defaultBranch = "main";
          log = {
            date = "relative";
            abbrevCommit = true;
          };
          merge.conflictStyle = "diff3";
          diff.colorMoved = "zebra";
          commit.gpgSign = false;
          interactive.singleKey = true;
          pull.rebase = true;
          rerere.enabled = true;
        }
        (lib.mkIf config.nvim.enable {
          core.editor = "nvim";
          diff.tool = "nvimdiff";
          merge.tool = "nvimdiff";
          difftool.prompt = false;
          mergetool = {
            prompt = false;
            keepBackup = false;
          };
        })
      ];

      includes =
        lib.optional (config.secrets.templatePath ? ${emailTemplate "personal"}) {
          path = config.secrets.templatePath.${emailTemplate "personal"};
        }
        ++ [
          {
            condition = "gitdir:~/work/";
            contents = workSettings;
            contentSuffix = "gitconfig-work";
          }
          {
            condition = "gitdir:~/nix-dev-shells/";
            contents = workSettings;
            contentSuffix = "gitconfig-work";
          }
        ];
    };
  };
}
