# ----------------------------
# Theme
# ----------------------------
zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
zinit light starship/starship

# ----------------------------
# Completions
# ----------------------------
zinit ice wait'0' lucid; zinit light zsh-users/zsh-completions
zinit ice wait'0' lucid; zinit light zsh-users/zsh-autosuggestions

# ----------------------------
# Syntax Highlighting
# ----------------------------
zinit ice wait'0' lucid; zinit light z-shell/F-Sy-H
