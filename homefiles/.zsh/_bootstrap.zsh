# ----------------------------
# Bootstrap: PATH setup that must run before tool activations (mise, direnv, ...).
# Loaded first because files in ~/.zsh are sourced in lexical order and `_` sorts
# before any alphabetic filename.
# ----------------------------

# homebrew
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# go
if type "go" > /dev/null 2>&1; then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# rust (binaries installed by `cargo install`)
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$PATH:$HOME/.cargo/bin"
fi
