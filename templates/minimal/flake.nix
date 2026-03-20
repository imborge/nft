{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (top@{ config, withSystem, ... }: {
      imports = [];
      flake = {};
      systems = [];
      perSystem = { config, pkgs, ... }: {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [];
        };
      };
    });
}
