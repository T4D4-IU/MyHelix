#!/usr/bin/env bash

# MyHelix Non-Nix Setup Script
# This script symlinks the configurations in this repository to ~/.config/

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
CONFIG_DIR="$HOME/.config"

echo "Setting up MyHelix configurations (Non-Nix mode)..."

# Helix
mkdir -p "$CONFIG_DIR/helix"
if [ -L "$CONFIG_DIR/helix/config.toml" ] || [ -f "$CONFIG_DIR/helix/config.toml" ]; then
    echo "Warning: $CONFIG_DIR/helix/config.toml already exists. Skipping."
else
    ln -s "$REPO_ROOT/config/helix/config.toml" "$CONFIG_DIR/helix/config.toml"
    echo "Linked Helix config."
fi

if [ -L "$CONFIG_DIR/helix/config-mobile.toml" ] || [ -f "$CONFIG_DIR/helix/config-mobile.toml" ]; then
    echo "Warning: $CONFIG_DIR/helix/config-mobile.toml already exists. Skipping."
else
    ln -s "$REPO_ROOT/config/helix/config-mobile.toml" "$CONFIG_DIR/helix/config-mobile.toml"
    echo "Linked Helix mobile config."
fi

# Zellij
mkdir -p "$CONFIG_DIR/zellij/layouts"
if [ -L "$CONFIG_DIR/zellij/config.kdl" ] || [ -f "$CONFIG_DIR/zellij/config.kdl" ]; then
    echo "Warning: $CONFIG_DIR/zellij/config.kdl already exists. Skipping."
else
    ln -s "$REPO_ROOT/config/zellij/config.kdl" "$CONFIG_DIR/zellij/config.kdl"
    echo "Linked Zellij config."
fi

if [ -L "$CONFIG_DIR/zellij/layouts/compact.kdl" ] || [ -f "$CONFIG_DIR/zellij/layouts/compact.kdl" ]; then
    echo "Warning: $CONFIG_DIR/zellij/layouts/compact.kdl already exists. Skipping."
else
    ln -s "$REPO_ROOT/config/zellij/layouts/compact.kdl" "$CONFIG_DIR/zellij/layouts/compact.kdl"
    echo "Linked Zellij compact layout."
fi

echo ""
echo "Setup complete!"
echo "Make sure you have 'helix' and 'zellij' installed via your package manager (e.g., brew, apt, cargo)."
