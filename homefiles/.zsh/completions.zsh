# ----------------------------
# Tool-specific completions
# ----------------------------
# NOTE: This file is sourced by .zshrc AFTER `compinit`. Registering `complete`
# / `eval "$(... completion)"` before compinit would run against an uninitialised
# completion system and have no effect. Keep this file out of the generic
# `*.zsh` auto-load loop.

# AWS CLI
if type "aws_completer" > /dev/null 2>&1; then
    complete -C "$(command -v aws_completer)" aws
fi

# aws-vault
if type "aws-vault" > /dev/null 2>&1; then
    eval "$(aws-vault --completion-script-zsh)"
fi

# gh (GitHub CLI)
if type "gh" > /dev/null 2>&1; then
    eval "$(gh completion -s zsh)"
fi
