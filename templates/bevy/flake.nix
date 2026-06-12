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

      perSystem = { self', config, pkgs, ... }: {

        rust-project = {
          crates.my-app = {
            path = ./.;
            crane.args = {
              buildInputs = with pkgs; [
                pkg-config
                clang
                llvmPackages_latest.bintools
                udev.dev
                libudev-zero
                alsa-lib.dev
                vulkan-loader
                xorg.libX11
                xorg.libXcursor
                xorg.libXi
                xorg.libXrandr
                libxkbcommon
                wayland.dev
                glibc.dev
                glib.dev
              ];
            };
          };
        };

        devShells.default = config.devShells.rust.overrideAttrs (old: rec {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
              pkgs.vulkan-loader
              pkgs.xorg.libX11
              pkgs.xorg.libXi
              pkgs.xorg.libXcursor
              pkgs.libxkbcommon
              pkgs.wayland
              pkgs.libudev-zero
              pkgs.udev
            ];
        });
        # package.default = self'.packages.main-crate;
      };
    });
}
