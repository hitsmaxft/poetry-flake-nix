{
  description = "poetry";


  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs";
      utils.url = "github:numtide/flake-utils";
      poetry2nix-src.url = "github:nix-community/poetry2nix";
      poetry-src.url = "github:python-poetry/poetry/1.5";
  };

  outputs = { nixpkgs, utils, poetry2nix-src, poetry-src, self }: utils.lib.eachDefaultSystem (system:
    let
      inherit (poetry2nix-src.legacyPackages.${system}) mkPoetryApplication;
      pkgs = import nixpkgs { inherit system; overlays = [ poetry2nix-src.overlay ]; };


    in {
      defaultPackage = pkgs.poetry2nix.mkPoetryApplication {
        projectDir = "${poetry-src}/";
      };

      devShell = pkgs.mkShell {

        # Add anything in here if you want it to run when we run `nix develop`.
        shellHook = ''
        '';
        buildInputs = with pkgs; [
          # Additional dev packages list here.
          nixpkgs-fmt
          nix-prefetch-git
          (pkgs.poetry2nix.mkPoetryEnv {
            projectDir = "${poetry-src}/";

            editablePackageSources = {
              my-app = "${poetry-src}/src";
            };
          })
        ];
      };

    });
}
