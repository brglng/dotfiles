# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source "$BRGLNG_DOTFILES_DIR/shell_rc_pre.sh"

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

if type powerline-daemon &>/dev/null; then
    powerline-daemon -q
fi

GIT_PS1_SHOWDIRTYSTATE=true

if [[ "$(uname -s)" = "Darwin" ]]; then
    if [[ -s /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.zsh ]]; then
        source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.zsh
    fi
    if [[ -s /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh ]]; then
        source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
    fi
elif [[ "$(uname -s)" = "Linux" ]]; then
    source /etc/bash_completion.d/git-prompt
fi

PS1='\[\e[0;32m\]\u@\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\] \[\e[1;93m\]$(__git_ps1 "(%s) ")\[\e[0m\]\$ '

if type brew &>/dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "$COMPLETION" ]] && source "$COMPLETION"
        done
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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

if [ -e ~/.local/share/z.lua ]; then
    eval "$(luajit ~/.local/share/z.lua --init bash)"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source "$BRGLNG_DOTFILES_DIR/shell_rc_post.sh"

# vim: ts=8 sts=4 sw=4 et
