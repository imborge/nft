{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devshell.url = "github:numtide/devshell";
  };

  outputs = inputs@{
    self,
      flake-parts,
      nixpkgs,
      ...
  }:
    flake-parts.lib.mkFlake  { inherit inputs; } (top@{ config, withSystem, ... }: {
      imports = [
        inputs.devshell.flakeModule
      ];

      flake = {
      };

      systems = [
        "x86_64-linux"
      ];
      perSystem = { config, pkgs, ... }: {
        devshells.default = {
          env = [];
          commands = [
            {
              help = "Initialize project";
              name = "init";
              command = "bb init";
            }
          ];
          packages = [
            pkgs.bun
            pkgs.babashka
          ];
        };
      };
    });
}
