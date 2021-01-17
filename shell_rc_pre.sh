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

update_environment() {
    if [[ -n $TMUX ]] && type tmux >/dev/null; then
        eval $(tmux showenv DISPLAY)
        eval $(tmux showenv KRB5CCNAME)
        eval $(tmux showenv SSH_ASKPASS)
        eval $(tmux showenv SSH_AUTH_SOCK)
        eval $(tmux showenv SSH_AGENT_PID)
        eval $(tmux showenv SSH_CONNECTION)
        eval $(tmux showenv WINDOWID)
        eval $(tmux showenv XAUTHORITY)
    fi
}

if [[ "`uname -s`" = Darwin ]]; then
    for minor in {0..20}; do
        [[ -d ~/Library/Python/3.${minor}/bin ]] && path_prepend ~/Library/Python/3.${minor}/bin
    done
fi

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"

if type brew &>/dev/null; then
    export HOMEBREW_PREFIX="$(brew --prefix)"
    eval $(brew shellenv | grep -v 'export PATH=')
fi

export NVM_DIR=~/.nvm

# make node and npm avalailable in the PATH
path_prepend "$NVM_DIR/versions/node/$(<$NVM_DIR/alias/default)/bin"

# lazy load nvm
if ! type nvm &>/dev/null; then
    nvm() {
        unset -f nvm
        if [[ -s "/usr/share/nvm/init-nvm.sh" ]]; then
            source "/usr/share/nvm/init-nvm.sh"
        else
            [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
            [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
        fi
        nvm "$@"
    }
fi

if [[ "$GOPATH" = "" ]]; then
    export GOPATH="$HOME/go"
    path_append "$GOPATH/bin"
fi

if type powerline-daemon &>/dev/null; then
    powerline-daemon -q
fi

# vim: ts=8 sts=4 sw=4 et ft=bash
