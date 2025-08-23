# --------------------------
# Plugin manager
# --------------------------
### Added by Zinit's installer
if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# --------------------------
# Loading split files
# --------------------------
# `completions.zsh` is excluded here because it must run after `compinit`.
ZSHHOME="${HOME}/.zsh"
if [ -d $ZSHHOME -a -r $ZSHHOME -a -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
        [[ ${i##*/} != completions.zsh ]] &&
            [ -f $i -a -r $i ] && . $i
    done
fi

# --------------------------
# Finalize completions
# --------------------------
# Run compinit after all plugins / tool activations have extended $fpath.
autoload -Uz compinit
compinit

# Register zinit's own completion function. This has to run after `compinit`
# because `$_comps` is only populated once `compinit` initialises the completion
# system; binding it earlier has no effect.
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Tool-specific completion generators (aws / aws-vault / gh / ...).
source "$ZSHHOME/completions.zsh"
