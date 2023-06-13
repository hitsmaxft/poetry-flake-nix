{
  description = "poetry";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs";
      utils.url = "github:numtide/flake-utils";
      poetry2nix-src.url = "github:nix-community/poetry2nix";
      flake-compat = {
        url = "github:edolstra/flake-compat";
        flake = false;
      };
  };

  outputs = {
    nixpkgs, utils, poetry2nix-src, flake-compat, self }:
    let 
      systems = ["x86_64-linux" "x86_64-darwin"];
    in
    utils.lib.eachSystem systems (system:
    let

      inherit (poetry2nix-src.legacyPackages.${system}) mkPoetryApplication mkPoetryEnv;

      pkgs = import nixpkgs { inherit system; overlays = [ poetry2nix-src.overlay ]; };

      poetry-src = pkgs.fetchFromGitHub {
        owner = "python-poetry";
        repo = "poetry";
        rev = "1.5.1";
        hash = "sha256-1zqfGzSI5RDACSNcz0tLA4VKMFwE5uD/YqOkgpzg2nQ=";
      };

    in {

      inherit flake-compat;

      defaultPackage = mkPoetryApplication {
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
          (mkPoetryEnv {
            projectDir = "${poetry-src}/";

            editablePackageSources = {
              my-app = "${poetry-src}/src";
            };
          })
        ];
      };

    });
  }
