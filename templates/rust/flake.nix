{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-flake.url = "github:juspay/rust-flake";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{
    self,
      flake-parts,
      nixpkgs,
      ...
  }:
    flake-parts.lib.mkFlake  { inherit inputs; } (top@{ config, withSystem, ... }: {
      imports = [
        inputs.rust-flake.flakeModules.default
        inputs.rust-flake.flakeModules.nixpkgs
      ];

      flake = {
      };

      systems = [
        "x86_64-linux"
      ];
      perSystem = { config, pkgs, ... }: {
        rust-project.crates.rust.path = ./.;
        devShells.default = config.devShells.rust;
      };
    });
}
