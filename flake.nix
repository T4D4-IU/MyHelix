{
  description = "Helix and Zellij configuration for remote and local development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    # Home Manager Module that can be imported from dotfiles
    homeManagerModules.default = { pkgs, ... }: {
      imports = [
        ./modules/helix.nix
        ./modules/zellij.nix
      ];
    };
  };
}
