if ! infocmp $TERM &> /dev/null; then
    export TERM=xterm-256color
fi

path_append() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$1"
    fi
}

path_prepend() {
    if [[ "$PATH" != "$1"* ]]; then
        export PATH="$1${PATH:+":$PATH"}"
    fi
}

update_environment() {
    if [[ -n $TMUX ]] && type tmux >/dev/null; then
        local cmd=$(tmux showenv DISPLAY)
        [[ ! $cmd =~ ^\- ]] && eval "export '$cmd'"
        local cmd=$(tmux showenv KRB5CCNAME)
        [[ ! $cmd =~ ^\- ]] && eval "export '$cmd'"
        local cmd=$(tmux showenv SSH_ASKPASS)
        [[ ! $cmd =~ ^\- ]] && eval "export '$cmd'"
        local cmd=$(tmux showenv SSH_AUTH_SOCK)
        [[ ! $cmd =~ ^\- ]] && eval "export '$cmd'"
        local cmd=$(tmux showenv SSH_AGENT_PID)
        [[ ! $cmd =~ ^\- ]] && eval "export '$cmd'"
        local cmd=$(tmux showenv SSH_CONNECTION)
        [[ ! $cmd =~ ^\- ]] && eval "export '$cmd'"
        local cmd=$(tmux showenv WINDOWID)
        [[ ! $cmd =~ ^\- ]] && eval "export '$cmd'"
        local cmd=$(tmux showenv XAUTHORITY)
        [[ ! $cmd =~ ^\- ]] && eval "export '$cmd'"
    fi
}

if [[ "`uname -s`" = Darwin ]]; then
    for minor in {0..100}; do
        [[ -d ~/Library/Python/3.${minor}/bin ]] && path_prepend ~/Library/Python/3.${minor}/bin
    done
fi

path_prepend "$HOME/.cargo/bin"

if type brew &>/dev/null; then
    export HOMEBREW_PREFIX="$(brew --prefix)"
    eval $(brew shellenv | grep -v 'export PATH=')
fi

path_prepend "$HOME/.pixi/bin"

export NVM_DIR=~/.nvm

# make node and npm avalailable in the PATH
path_prepend "$NVM_DIR/versions/node/$(<$NVM_DIR/alias/default)/bin"

# lazy load nvm
if [[ -s "/usr/share/nvm/init-nvm.sh" ]]; then
    source "/usr/share/nvm/init-nvm.sh"
else
    [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
    [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

if [[ "$GOPATH" = "" ]]; then
    export GOPATH="$HOME/go"
    path_append "$GOPATH/bin"
fi

path_prepend "$HOME/.local/bin"

# if type powerline-daemon &>/dev/null; then
#     powerline-daemon -q
# fi

# vim: ts=8 sts=4 sw=4 et ft=bash
