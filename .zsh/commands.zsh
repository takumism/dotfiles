# ----------------------------
# cat / bat
# ----------------------------
if type "bat" > /dev/null 2>&1; then
    alias cat="bat"
fi

# ----------------------------
# cd
# ----------------------------
# auto cd
setopt AUTO_CD
cdpath=(.. ~ ~/src)

# auto ls
chpwd() {
	if [[ $(pwd) != $HOME ]]; then;
		ls
	fi
}

# ----------------------------
# editors
# ----------------------------
alias v="nvim"

# ----------------------------
# fzf
# ----------------------------
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

# ----------------------------
# git
# ----------------------------
alias g="git"

# ----------------------------
# go
# ----------------------------
if type "go" > /dev/null 2>&1; then
    export GO111MODULE=on
    export PATH="$(go env GOROOT)/bin:$PATH"
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# ----------------------------
# gpg
# ----------------------------
#  Set the GPG_TTY variable to the standard output destination of the current terminal.
export GPG_TTY=$(tty)

# ----------------------------
# grep / ripgrep
# ----------------------------
if type "rg" > /dev/null 2>&1; then
    alias grep="rg"
fi

# ----------------------------
# homebrew
# ----------------------------
eval $(/opt/homebrew/bin/brew shellenv)

# ----------------------------
# kubectl
# ----------------------------
alias k="kubectl"

# ----------------------------
# ls / exa
# ----------------------------
if type "eza" > /dev/null 2>&1; then
    alias ls="eza --icons"
fi
export LSCOLORS=gxfxcxdxbxegedabagacad

# ----------------------------
# lazygit
# ----------------------------
alias lg="lazygit"

# ----------------------------
# nix
# ----------------------------
if [ "$(uname)" != "Darwin" ] ; then
    export DARWIN_USER=$(whoami)
    export DARWIN_HOST=$(hostname -s)
fi

# ----------------------------
# mise
# ----------------------------
if type "mise" > /dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# ----------------------------
# rust
# ----------------------------
export PATH="$PATH:$HOME/.cargo/bin"
