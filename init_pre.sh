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

if [[ `uname -s` = Darwin ]]; then
    readlinkf() { echo `greadlink -f "$1"`; }
else
    readlinkf() { echo `readlink -f "$1"`; }
fi

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"

if [ "$NVM_DIR" = "" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "`brew --prefix`/opt/nvm/nvm.sh" ] && . "`brew --prefix`/opt/nvm/nvm.sh"  # This loads nvm
fi

if [ "$GOPATH" = "" ]; then
    export GOPATH="$HOME/go"
    path_append 
fi

export HOMEBREW_NO_AUTO_UPDATE=1

# vim: ts=8 sts=4 sw=4 et
