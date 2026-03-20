{
  description = "Nix Flake Templates";

  inputs = {
  };

  outputs = { self, ... }: {
    templates = {
      rust = {
        path = ./templates/rust;
        description = "A simple rust nix flake template";
      };
      clj = {
        path = ./templates/clj;
        description = "A simple clojure nix flake template";
      };
      minimal = {
        path = ./templates/minimal;
        description = "A minimal nix flake template";
      };
      defaultTemplate = self.templates.minimal;
    };
  };
}
