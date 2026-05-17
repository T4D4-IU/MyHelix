{
  description = "Helix and Zellij configuration for remote and local development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    let
      # Home Manager Module definition
      hmModule = { pkgs, ... }: {
        imports = [
          ./modules/helix.nix
          ./modules/zellij.nix
        ];
      };
    in
    {
      # Export module for use in other flakes
      homeManagerModules.default = hmModule;
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Portable MyHelix wrapper
        myhelix = pkgs.writeShellScriptBin "myhelix" ''
          set -e
          # Create a temporary config home to avoid touching user's ~/.config
          export XDG_CONFIG_HOME=$(mktemp -d /tmp/myhelix-XXXXXX)
          trap 'rm -rf "$XDG_CONFIG_HOME"' EXIT

          mkdir -p "$XDG_CONFIG_HOME/helix"
          mkdir -p "$XDG_CONFIG_HOME/zellij/layouts"

          # Symlink configurations from the Nix store
          ln -s "${./config/helix/config.toml}" "$XDG_CONFIG_HOME/helix/config.toml"
          ln -s "${./config/helix/config-mobile.toml}" "$XDG_CONFIG_HOME/helix/config-mobile.toml"
          ln -s "${./config/zellij/config.kdl}" "$XDG_CONFIG_HOME/zellij/config.kdl"
          ln -s "${./config/zellij/layouts/compact.kdl}" "$XDG_CONFIG_HOME/zellij/layouts/compact.kdl"

          # Use a dedicated Zellij session name
          export ZELLIJ_CONFIG_DIR="$XDG_CONFIG_HOME/zellij"
          
          echo "Starting MyHelix (Standalone Mode)..."
          ${pkgs.zellij}/bin/zellij --layout "${./config/zellij/layouts/compact.kdl}" "$@"
        '';
      in
      {
        packages.default = myhelix;
        apps.default = {
          type = "app";
          program = "${myhelix}/bin/myhelix";
        };
        
        # Development shell for testing
        devShells.default = pkgs.mkShell {
          buildInputs = [ myhelix pkgs.helix pkgs.zellij ];
        };
      }
    ));
}

