#!/usr/bin/env bash
set -euo pipefail

USER_NAME="takumism"

# Install Determinate Nix.
# ref. https://determinate.systems/posts/determinate-nix-installer/
if ! command -v /nix/var/nix/profiles/default/bin/nix &>/dev/null; then
    echo "Installing Determinate Nix..."
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
fi

# Install Homebrew (required for a small set of casks such as google-japanese-ime).
# ref. https://brew.sh/
if ! command -v /opt/homebrew/bin/brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Apply the nix-darwin configuration.
/nix/var/nix/profiles/default/bin/nix run \
    --extra-experimental-features "nix-command flakes" \
    nix-darwin -- switch --flake ".#${USER_NAME}"
