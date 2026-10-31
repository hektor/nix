{
  nixpkgs,
  git-hooks,
  system,
  src,
}:
let
  pkgs = nixpkgs.legacyPackages.${system};

  pre-commit-check = git-hooks.lib.${system}.run {
    inherit src;

    default_stages = [ "pre-commit" ];

    hooks = {
      nixfmt = {
        enable = true;
        package = pkgs.nixfmt;
      };
      statix.enable = true;
      deadnix.enable = true;

      flake-check = {
        enable = true;
        entry = "${pkgs.lib.getExe pkgs.nix} flake check";
        stages = [ "pre-push" ];
        pass_filenames = false;
        always_run = true;
      };
    };
  };
in
{
  checks.pre-commit-check = pre-commit-check;

  formatter = pkgs.nixfmt-tree;

  devShells.default = pkgs.mkShell {
    inherit (pre-commit-check) shellHook;
    packages = pre-commit-check.enabledPackages;
  };
}
