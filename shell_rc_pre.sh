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
    export HOMEBREW_PREFIX="$(brew --prefix)"
else
    echo "Homebrew not found!"
    exit -1
fi

# lazy load nvm, node and npm
if type nvm &>/dev/null; then
    nvm() {
        unset -f nvm
        export NVM_DIR=~/.nvm
        [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
        [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
        nvm "$@"
    }
fi

if type node &>/dev/null; then
    node() {
        unset -f node
        export NVM_DIR=~/.nvm
        [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
        [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
        node "$@"
    }
fi

if type npm &>/dev/null; then
    npm() {
        unset -f npm
        export NVM_DIR=~/.nvm
        [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
        [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
        npm "$@"
    }
fi

if [[ "$GOPATH" = "" ]]; then
    export GOPATH="$HOME/go"
    path_append "$GOPATH/bin"
fi

export HOMEBREW_NO_AUTO_UPDATE=1

# vim: ts=8 sts=4 sw=4 et
