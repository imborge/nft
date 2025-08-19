{
  description = "Nix Flake Templates";

  inputs = {
  };

  outputs = { self, ... }: {
    templates = {
      minimal = {
        path = ./templates/minimal;
        description = "A minimal nix flake template";
      };
      defaultTemplate = self.templates.minimal;
    };
  };
}
