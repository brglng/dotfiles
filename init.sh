path_append() {
    if [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
    fi
}

path_prepend() {
    if [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"

if [ "$NVM_DIR" = "" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm
fi

if [ "$GOPATH" = "" ]; then
    export GOPATH="$HOME/go"
    path_append 
fi

# Preferred editor for local and remote sessions
if which nvim > /dev/null; then
    export EDITOR='nvim'
    alias vi=nvim
elif which vim > /dev/null; then
    export EDITOR='vim'
    alias vi=vim
elif which nano > /dev/null; then
    export EDITOR='nano'
fi

if [ `uname -s` = Darwin ]; then
    alias ls="/usr/local/bin/gls -hF --color=auto"
else
    alias ls="ls --group-directories-first -hF --color=auto"
fi

if which colordiff > /dev/null; then
    alias diff='colordiff'
fi

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias t='tmux attach || tmux new'

if [ `uname -s` = Darwin ]; then
    alias ll='/usr/local/bin/gls -ahlF --color=auto'
    alias la='/usr/local/bin/gls -AhF --color=auto'
    alias l='/usr/local/bin/gls -hF --color=auto'
    alias df='/usr/local/bin/gdf -h'
    alias du='/usr/local/bin/gdu -c -h'
    alias mkdir='/usr/local/bin/gmkdir -p -v'
    alias cp='/usr/local/bin/gcp -i'
    alias mv='/usr/local/bin/gmv -i'
    alias rm='/usr/local/bin/grm -I'
    alias ln='/usr/local/bin/gln -i'
    alias chown='/usr/local/bin/gchown --preserve-root'
    alias chmod='/usr/local/bin/gchmod --preserve-root'
    alias chgrp='/usr/local/bin/gchgrp --preserve-root'
else
    alias ll='ls -al --color -F'
    alias la='ls -A --color -F'
    alias l='ls --color -F'
    alias df='df -h'
    alias du='du -c -h'
    alias mkdir='mkdir -p -v'
    alias cp='cp -i'
    alias mv='mv -i'
    alias rm='rm -I'
    alias ln='ln -i'
    alias chown='chown --preserve-root'
    alias chmod='chmod --preserve-root'
    alias chgrp='chgrp --preserve-root'
fi

alias more='less'
alias ping='ping -c 5'

alias t='tmux attach > /dev/null 2>&1 || tmux new'

# z.lua aliases
alias zh='z -I -t .'
alias zz='z -c'      # restrict matches to subdirs of $PWD
alias zi='z -i'      # cd with interactive selection
alias zf='z -I'      # use fzf to select in multiple matches
alias zb='z -b'      # quickly cd to the parent directory

# vim: ts=8 sts=4 sw=4 et
