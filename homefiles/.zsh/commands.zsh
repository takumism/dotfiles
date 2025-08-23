# ----------------------------
# cd
# ----------------------------
# auto ls
chpwd() {
    [[ $(pwd) != $HOME ]] && ls
}

# ----------------------------
# editors
# ----------------------------
alias v="nvim"

# ----------------------------
# fzf
# ----------------------------
if type "fzf" > /dev/null 2>&1; then
    source <(fzf --zsh)

    # Default Setting
    export FZF_DEFAULT_COMMAND="fd --type file -I -H -E '.git/'"
    export FZF_DEFAULT_OPTS="
        --height 90% --reverse --border
        --prompt='➜ ' --margin=1,1 --inline-info
        --select-1 --exit-0 --multi
        --color fg:-1,bg:-1,hl:33,fg+:250,bg+:235,hl+:33
        --color info:37,prompt:37,pointer:230,marker:230,spinner:37
        --preview 'bat -r :100 --color=always --style=header,grid {}'
    "

    # File Search
    export FZF_CTRL_F_COMMAND="fd --type file -I -H -E '.git/'"
    export FZF_CTRL_F_OPTS="
        --preview 'bat -r :100 --color=always --style=header,grid {}'
    "

    # History Search
    export FZF_CTRL_R_OPTS="
        --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'
    "
fi

# ----------------------------
# git
# ----------------------------
alias g="git"

# ----------------------------
# ls / eza
# ----------------------------
# Using eza as a drop-in replacement for ls. LSCOLORS is intentionally omitted
# because eza manages its own colors.
if type "eza" > /dev/null 2>&1; then
    alias ls="eza --icons"
    alias ll="eza -lh --icons --git"
    alias la="eza -a --icons"
    alias tree="eza --tree --icons"
fi

# ----------------------------
# lazygit
# ----------------------------
alias lg="lazygit"

# ----------------------------
# ripgrep
# ----------------------------
# Point ripgrep at its config file. Without this env var, ripgrep ignores
# any file in ~/.config/ripgrep — the config path is NOT auto-discovered.
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep/ripgreprc"

# ----------------------------
# mise
# ----------------------------
if type "mise" > /dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# ----------------------------
# direnv
# ----------------------------
if type "direnv" > /dev/null 2>&1; then
    # Suppress the "direnv: loading .envrc" chatter.
    export DIRENV_LOG_FORMAT=""
    eval "$(direnv hook zsh)"
fi

# ----------------------------
# zoxide
# ----------------------------
# Replace `cd` itself with zoxide so fuzzy jumps ("cd foo") and plain cd both work.
if type "zoxide" > /dev/null 2>&1; then
    eval "$(zoxide init zsh --cmd cd)"
fi

# ----------------------------
# yazi
# ----------------------------
alias y="yazi"

# ----------------------------
# atuin
# ----------------------------
# Loaded after fzf so that atuin's Ctrl-R binding takes precedence.
# `--disable-up-arrow` keeps the default zsh up-arrow history search in
# config.zsh (prefix-based) instead of opening atuin's full-screen UI.
if type "atuin" > /dev/null 2>&1; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi
