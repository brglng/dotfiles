path_append() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

path_prepend() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

if [[ "`uname -s`" = Darwin ]]; then
    [[ -d ~/Library/Python/3.5/bin ]] && path_prepend ~/Library/Python/3.5/bin
    [[ -d ~/Library/Python/3.6/bin ]] && path_prepend ~/Library/Python/3.6/bin
    [[ -d ~/Library/Python/3.7/bin ]] && path_prepend ~/Library/Python/3.7/bin
    [[ -d ~/Library/Python/3.8/bin ]] && path_prepend ~/Library/Python/3.8/bin
fi

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"

if type brew &>/dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"
else
    echo "Homebrew not found!"
    exit -1
fi

if [[ "$NVM_DIR" = "" && $HOMEBREW_PREFIX != "" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
fi

if [[ "$GOPATH" = "" ]]; then
    export GOPATH="$HOME/go"
    path_append 
fi

export HOMEBREW_NO_AUTO_UPDATE=1

# vim: ts=8 sts=4 sw=4 et