# dotfiles
## Installation

```shell
xcode-select --install

git clone https://github.com/takumism/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

- Modify the flake.nix file according to your environment.

```shell
username = "username";
platform = "aarch64-darwin"; # or "x86_64-linux"
```

- Run the following command to apply the configuration.

```shell
./install.sh
```

# Update packages

- Update each package by rebuilding environment.
- Run the `nix flake update` if you want to update nix packages.

```shell
# Fetch the latest package information
nix flake update
# Apply the home-manager configuration
nix run nix-darwin -- switch --flake .#username
```
