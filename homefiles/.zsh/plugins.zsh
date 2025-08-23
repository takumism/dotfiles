# ----------------------------
# Theme
# ----------------------------
# Install starship from its GitHub Releases as a plain binary. `atclone` generates
# the zsh init script and completions once, and `atpull"%atclone"` re-runs the same
# steps when zinit updates the plugin.
zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
zinit light starship/starship

# ----------------------------
# Completions
# ----------------------------
# zsh-completions ships additional completion files that must be on $fpath before
# `compinit` runs. Loading it synchronously (no `wait`) guarantees that ordering;
# `compinit` is invoked at the end of .zshrc.
zinit light zsh-users/zsh-completions

# zsh-autosuggestions only adds a ZLE widget, so it's safe to defer with `wait'0'`.
zinit ice wait'0' lucid
zinit light zsh-users/zsh-autosuggestions

# ----------------------------
# Syntax Highlighting
# ----------------------------
# F-Sy-H must be loaded after the prompt is ready, so lazy-load it.
zinit ice wait'0' lucid
zinit light z-shell/F-Sy-H
