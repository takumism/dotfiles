# dotfiles

macOS (Apple Silicon) personal environment managed by
[nix-darwin](https://github.com/LnL7/nix-darwin) +
[home-manager](https://github.com/nix-community/home-manager) +
[Determinate Nix](https://determinate.systems/).

## Layout

- `flake.nix` — flake entry point (inputs, `darwinConfigurations`, `homeConfigurations`, formatter).
- `nix-darwin.nix` — system-level settings (Determinate Nix, Homebrew casks, `system.defaults`, ...).
- `home-manager.nix` — user-level packages, `home.file`, `xdg.configFile`.
- `homefiles/` — files that are symlinked into `$HOME` (e.g. `.zshrc`, `.gitconfig`).
- `configfiles/` — files that are symlinked into `$XDG_CONFIG_HOME` (`~/.config`).

## Tooling boundaries

Each layer has a narrow responsibility. When adding something new, pick the
layer below and avoid overlapping managers.

| Layer | Scope | What goes here | Where it is declared |
|---|---|---|---|
| **Determinate Nix** | Nix daemon / store | The Nix runtime itself, daemon settings, garbage collection | Installed by `install.sh`; integrated via `determinateNix.enable = true;` in `nix-darwin.nix`. |
| **nix-darwin** | macOS system settings | `system.defaults` (Dock, Finder, ...), `launchd` services, `environment.shells`, `homebrew = { ... }` declaration, `system.primaryUser` | `nix-darwin.nix` |
| **home-manager** | Per-user files and CLI packages | CLI tools (`gh`, `lazygit`, `jq`, ...), fonts, `home.file` / `xdg.configFile` symlinks | `home-manager.nix` + `homefiles/` + `configfiles/` |
| **Homebrew (casks)** | macOS GUI apps that aren't in nixpkgs | Apps that need OS integration (input methods, kernel extensions) or aren't packaged for `aarch64-darwin` (e.g. `google-japanese-ime`, `onyx`, `claude` desktop) | `homebrew.casks` in `nix-darwin.nix` |
| **mise** | Per-project language runtimes | Go, Rust, and any runtime that benefits from per-directory version switching | `configfiles/mise/config.toml` |

### Decision guide

When adding a new tool, ask in order:

1. **Is it a GUI app?**
   - In nixpkgs (e.g. `obsidian`, `vscode`): add to `home.packages`.
   - Not in nixpkgs, or needs deep OS integration: add to `homebrew.casks`.

2. **Is it a language runtime (rustc, node, python, go, ...)**?
   - Use **mise**. Keeps versions switchable per project and avoids rebuilding
     the Nix store each time a version is bumped.

3. **Is it a CLI tool?**
   - Default: add to `home.packages` in `home-manager.nix` for reproducible,
     lock-file pinned installs.
   - Avoid using Homebrew for CLIs — it bypasses the flake lock.

4. **Is it a dotfile**?
   - Goes under `$HOME`: put it in `homefiles/`.
   - Goes under `~/.config` (XDG): put it in `configfiles/`.
   - Both directories are auto-synced via `builtins.readDir`; no `home-manager.nix`
     changes are required for new files.

### Why this split?

- **Nix/home-manager first** maximises reproducibility: `flake.lock` pins exact
  versions across machines.
- **Homebrew remains** because a handful of macOS-only apps (input methods,
  maintenance utilities) can't practically be packaged via Nix.
- **mise handles languages** because per-project version pinning is painful in
  pure Nix, and language toolchains change more often than system tools.

## Installation

```shell
xcode-select --install

git clone https://github.com/takumism/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Edit `flake.nix` if you need a different username / system:

```nix
username = "takumism";
system = "aarch64-darwin";
```

Then run:

```shell
./install.sh
```

`install.sh` installs Determinate Nix (if missing), Homebrew (if missing), and
applies the nix-darwin configuration.

## Updating

```shell
# Pull the latest input revisions into flake.lock.
nix flake update

# Re-apply the full nix-darwin + home-manager configuration.
sudo darwin-rebuild switch --flake ".#takumism"

# Apply the home-manager layer only (useful for quick iteration).
sudo nix run home-manager -- switch --flake ".#takumism"

# Grabage collection
nix-collect-garbage
```

## Formatting

```shell
nix fmt
```
