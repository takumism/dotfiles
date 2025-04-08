#!/bin/bash

USER_NAME="takumism"

# Install Nix.
# ref. https://nixos.org/download/
if ! command -v /nix/var/nix/profiles/default/bin/nix &> /dev/null; then
  echo "Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install)
fi

# Install Homebrew.
# ref. https://brew.sh/ja/
if ! command -v /opt/homebrew/bin/brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Activate Rosseta 2.
arch -x86_64 /usr/bin/true 2>/dev/null || \
  softwareupdate --install-rosetta --agree-to-license

# apply the configuration.
/nix/var/nix/profiles/default/bin/nix run --extra-experimental-features \
  nix-command --extra-experimental-features \
  flakes nix-darwin -- switch --flake .#$USER_NAME
