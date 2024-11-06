path_prepend "$HOME/.local/bin"

setup_wsl_env() {
    pushd /mnt/c > /dev/null
    winpath=$(/mnt/c/Windows/System32/cmd.exe /c 'echo %PATH:\\=/%')
    popd > /dev/null
    winpath=$(echo $winpath | sed 's/ /\?/g' | tr ';' ' ')
    for p in $(echo $winpath); do
        p=$(echo "$p" | sed 's/\?/ /g')
        p=$(/usr/bin/wslpath -u "$p")
        path_append "$p"
    done
    export DISPLAY=:0
    export WAYLAND_DISPLAY=wayland-0
}

if [[ -x /mnt/c/Windows/System32/cmd.exe ]]; then
    setup_wsl_env
fi

# Preferred editor for local and remote sessions
if type nvim &> /dev/null; then
    export EDITOR='nvim'
    alias vi=nvim
elif type vim &> /dev/null; then
    export EDITOR='vim'
    alias vi=vim
elif type vi &> /dev/null; then
    export EDITOR='vi'
elif type nano &> /dev/null; then
    export EDITOR='nano'
fi

if [[ $(uname -s) = "Darwin" ]]; then
    alias ls="gls -hF --color=auto"
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

if [[ $(uname -s) = "Darwin" ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        alias ll='/opt/homebrew/bin/gls -ahlF --color=auto'
        alias la='/opt/homebrew/bin/gls -AhF --color=auto'
        alias l='/opt/homebrew/bin/gls -hF --color=auto'
        alias df='/opt/homebrew/bin/gdf -h'
        alias du='/opt/homebrew/bin/gdu -c -h'
        alias mkdir='/opt/homebrew/bin/gmkdir -p -v'
        alias cp='/opt/homebrew/bin/gcp -i'
        alias mv='/opt/homebrew/bin/gmv -i'
        alias rm='/opt/homebrew/bin/grm -I'
        alias ln='/opt/homebrew/bin/gln -i'
        alias chown='/opt/homebrew/bin/gchown --preserve-root'
        alias chmod='/opt/homebrew/bin/gchmod --preserve-root'
        alias chgrp='/opt/homebrew/bin/gchgrp --preserve-root'
    elif [[ -x /usr/local/bin/brew ]]; then
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
    fi
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
alias ssh='TERM=xterm-256color ssh'
alias ping='ping -c 5'

# z.lua aliases
alias zh='z -I -t .'
alias zz='z -c'      # restrict matches to subdirs of $PWD
alias zi='z -i'      # cd with interactive selection
alias zf='z -I'      # use fzf to select in multiple matches
alias zb='z -b'      # quickly cd to the parent directory
alias zbi='z -b -i'
alias zbf='z -b -I'

stty -ixon > /dev/null 2>&1 || true

# vim: ts=8 sts=4 sw=4 et ft=bash
