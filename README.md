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
| **home-manager / nixpkgs** | Bootstrap CLI, fonts, dotfile symlinks | Shell/bootstrap tools (`git`, `curl`, `direnv`, `mise`, `zsh`, ...), fonts, `home.file` / `xdg.configFile` symlinks | `home-manager.nix` + `homefiles/` + `configfiles/` |
| **Homebrew (casks)** | macOS GUI apps that aren't in nixpkgs | Apps that need OS integration (input methods, kernel extensions) or aren't packaged for `aarch64-darwin` (e.g. `google-japanese-ime`, `onyx`, `claude` desktop) | `homebrew.casks` in `nix-darwin.nix` |
| **mise** | Developer tools and language runtimes | Go, Rust, cloud CLIs, editor/tools, and optional CLIs that can be installed from prebuilt releases | `configfiles/mise/config.toml` |

### Decision guide

When adding a new tool, ask in order:

1. **Is it a GUI app?**
   - In nixpkgs (e.g. `obsidian`, `vscode`): add to `home.packages`.
   - Not in nixpkgs, or needs deep OS integration: add to `homebrew.casks`.

2. **Is it a language runtime (rustc, node, python, go, ...)**?
   - Use **mise**. Keeps versions switchable per project and avoids rebuilding
     the Nix store each time a version is bumped.
   - In the global mise config, use fuzzy versions such as `latest` with
     `minimum_release_age = "7d"` so newly released versions are ignored for a
     week. Pin exact versions in project-local `mise.toml` files when a project
     requires reproducibility.
   - Do not add language runtimes to `home.packages` unless a non-project,
     system-level tool explicitly needs the nixpkgs build.

3. **Is it a CLI tool?**
   - Default: add to `configfiles/mise/config.toml` if mise can install it from
     a prebuilt release or language package registry.
   - If the CLI must track the active project runtime, declare it in the
     project-local `mise.toml`. Otherwise declare it in the global mise config.
   - Add it to `home.packages` only when it is needed before mise is available,
     is not available in mise, or needs nix-darwin/home-manager integration.
   - Avoid using Homebrew for CLIs — it bypasses the flake lock.

4. **Is it a dotfile**?
   - Goes under `$HOME`: put it in `homefiles/`.
   - Goes under `~/.config` (XDG): put it in `configfiles/`.
   - Both directories are auto-synced via `builtins.readDir`; no `home-manager.nix`
     changes are required for new files.

### Why this split?

- **Nix/home-manager stays small** to keep rebuilds fast and reduce Nix store
  usage. It should bootstrap the shell, Nix, mise, and dotfile symlinks.
- **Homebrew remains** because a handful of macOS-only apps (input methods,
  maintenance utilities) can't practically be packaged via Nix.
- **mise handles developer tools** because language runtimes and web-development
  CLIs change often and usually do not need full Nix reproducibility.

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
mise install
```

`install.sh` installs Determinate Nix (if missing), Homebrew (if missing), and
applies the nix-darwin configuration. `mise install` installs the developer
tools declared in `configfiles/mise/config.toml`.

## Updating

```shell
# Pull the latest input revisions into flake.lock.
nix flake update

# Re-apply the full nix-darwin + home-manager configuration.
sudo darwin-rebuild switch --flake ".#takumism"

# Apply the home-manager layer only (useful for quick iteration).
nix run home-manager -- switch --flake ".#takumism"

# Install / update developer tools managed by mise.
mise install

# Garbage collection
nix-collect-garbage
```

## Formatting

```shell
nix fmt
```
