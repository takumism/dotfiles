# ----------------------------
# Auto Complete
# ---------------------------
autoload -Uz compinit
compinit

setopt always_to_end     # always move the cursor to the end of a completed word.
setopt complete_in_word  # completion at the cursor position.
setopt noautoremoveslash # when selecting a directory, leave the last /.
setopt list_packed       # display the completion candidates as packed as possible.
setopt list_types        # identification mark displays the type of file.

zstyle ':completion::complete:*' use-cache true     # enable caching of completion candidates.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive.

# ----------------------------
# Color
# ----------------------------
autoload -Uz colors
colors
# 補完候補一覧の色設定
zstyle ':completion:*' list-colors "${LS_COLORS}"

# ----------------------------
# Editor
# ----------------------------
export EDITOR="nvim"

# ----------------------------
# Language
# ----------------------------
if [ -z $$LC_ALL ]; then
  export LC_ALL=C
fi
if [ -z $LANG ]; then
  export LANG=ja_JP.UTF-8
fi

# ----------------------------
# History
# ----------------------------
HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=100000

setopt append_history       # append command history list.
setopt hist_ignore_all_dups # ignore duplication command history list.
setopt hist_ignore_space    # ignore space command history list.
setopt hist_no_store        # do not store command history list.
setopt hist_reduce_blanks   # reduce continuous blank lines to one.
setopt inc_append_history   # append command history list in real time.
setopt share_history        # share command history list.

# Searches the history for commands that begin with the characters you entered
# and completes them with the up and down arrows key.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# ----------------------------
# Others
# ----------------------------
alias loadzshrc="source $HOME/.zshrc"
alias relogin='exec $SHELL -l'
