# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export PATH=~/.local/bin:$PATH

set -o notify

shopt -s nocaseglob

# append to the history file, don't overwrite it
shopt -s histappend

shopt -s cdspell

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Don't put duplicate lines in the history.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups:ignorespace

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color)
    color_prompt=yes
    ;;
  *)
    TERM=xterm-256color
    ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    export CLICOLOR="true"
  else
    color_prompt=
  fi
fi

if [ $(uname -s) = Darwin ]; then
  if [ -n "$BASH" ]; then
    source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
  fi
  source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
fi

GIT_PS1_SHOWDIRTYSTATE=true

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\e[0;32m\]\u@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]$(__git_ps1 "(%s)")\n\$\[\e[m\] '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias diff='colordiff'
  if [ $(uname -s) = Darwin ]; then
    alias ls='/usr/local/bin/gls -hF --color=auto'
  else
    alias ls='ls -hF --color=auto'
  fi
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
fi

if [ $(uname -s) = Darwin ]; then
  alias ll='/usr/local/bin/gls -alF'
  alias la='/usr/local/bin/gls -A'
  alias l='/usr/local/bin/gls -CF'
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
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias t='tmux attach || tmux new'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f /etc/bash_completion.d/git ]; then
  source /etc/bash_completion.d/git
fi

set show-all-if-ambiguous on

if [ -n "$BASH" ]; then
  if [ -e /usr/local/share/autojump/autojump.bash ]; then
    source /usr/local/share/autojump/autojump.bash
  elif [ -e /usr/share/autojump/autojump.bash ]; then
    source /usr/share/autojump/autojump.bash
  fi

  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  if [ $(uname -s) = Darwin ]; then
    source ~/Library/Python/3.6/lib/python/site-packages/powerline/bindings/bash/powerline.sh
  else
    if [ -e ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]; then
      . ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
    elif [ -e ~/.local/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh ]; then
      . ~/.local/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh
    elif [ -e /usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh ]; then
      . /usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh
    elif [ -e ~/.local/lib/python3.4/site-packages/powerline/bindings/bash/powerline.sh ]; then
      . ~/.local/lib/python3.4/site-packages/powerline/bindings/bash/powerline.sh
    elif [ -e /usr/local/lib/python3.4/dist-packages/powerline/bindings/bash/powerline.sh ]; then
      . /usr/local/lib/python3.4/dist-packages/powerline/bindings/bash/powerline.sh
    fi
  fi
fi

export GEEKNOTE_BASE=yinxiang

export GOPATH=$HOME/.local/gopath
export PATH=$GOPATH/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
