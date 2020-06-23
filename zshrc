# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source "$BRGLNG_DOTFILES_DIR/shell_rc_pre.sh"

if [[ $HOMEBREW_PREFIX != "" ]]; then
    FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
fi

source ~/.zinit/bin/zinit.zsh

# most themes use this option
setopt promptsubst

# common OMZ libraries
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/correction.zsh
zinit snippet OMZ::lib/directories.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/termsupport.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh

# some OMZ themes use this plugin
zinit ice svn lucid
zinit snippet OMZ::plugins/git

zinit ice atload'!source ~/.p10k.zsh' lucid nocd
zinit light romkatv/powerlevel10k

zinit ice svn lucid
zinit snippet OMZ::plugins/adb

zinit ice svn lucid
zinit snippet OMZ::plugins/autopep8

zinit ice svn lucid
zinit snippet OMZ::plugins/brew

zinit ice svn lucid
zinit snippet OMZ::plugins/cargo

zinit ice svn lucid
zinit snippet OMZ::plugins/command-not-found

zinit ice svn lucid
zinit snippet OMZ::plugins/common-aliases

zinit ice svn lucid
zinit snippet OMZ::plugins/colorize

zinit ice svn lucid
zinit snippet OMZ::plugins/colored-man-pages

zinit ice svn lucid
zinit snippet OMZ::plugins/docker

zinit ice svn lucid
zinit snippet OMZ::plugins/docker-compose

zinit ice svn lucid
zinit snippet OMZ::plugins/emacs

zinit ice svn lucid
zinit snippet OMZ::plugins/emoji

zinit ice svn lucid
zinit snippet OMZ::plugins/fd

zinit ice svn lucid
zinit snippet OMZ::plugins/gem

zinit ice svn lucid
zinit snippet OMZ::plugins/git-flow

zinit ice svn lucid
zinit snippet OMZ::plugins/github

zinit ice svn lucid
zinit snippet OMZ::plugins/gitignore

zinit ice svn lucid
zinit snippet OMZ::plugins/gnu-utils

zinit ice svn lucid
zinit snippet OMZ::plugins/golang

zinit ice svn lucid
zinit snippet OMZ::plugins/gradle

zinit ice svn lucid
zinit snippet OMZ::plugins/mercurial

zinit ice svn lucid
zinit snippet OMZ::plugins/man

zinit ice svn lucid
zinit snippet OMZ::plugins/mvn

zinit ice svn lucid
zinit snippet OMZ::plugins/node

zinit ice svn lucid
zinit snippet OMZ::plugins/npm

zinit ice svn lucid
zinit snippet OMZ::plugins/nvm

zinit ice svn lucid
zinit snippet OMZ::plugins/osx

zinit ice svn lucid
zinit snippet OMZ::plugins/perl

zinit ice svn lucid
zinit snippet OMZ::plugins/pip

zinit ice svn lucid
zinit snippet OMZ::plugins/pipenv

zinit ice svn lucid
zinit snippet OMZ::plugins/pylint

zinit ice svn lucid
zinit snippet OMZ::plugins/python

zinit ice svn lucid
zinit snippet OMZ::plugins/redis-cli

zinit ice svn lucid
zinit snippet OMZ::plugins/repo

zinit ice svn lucid
zinit snippet OMZ::plugins/ripgrep

zinit ice svn lucid
zinit snippet OMZ::plugins/rsync

zinit ice svn lucid
zinit snippet OMZ::plugins/ruby

zinit ice svn lucid
zinit snippet OMZ::plugins/rust

zinit ice svn lucid
zinit snippet OMZ::plugins/rustup

zinit ice svn lucid
zinit snippet OMZ::plugins/sudo

zinit ice svn lucid
zinit snippet OMZ::plugins/supervisor

zinit ice svn lucid
zinit snippet OMZ::plugins/svn

zinit ice svn lucid
zinit snippet OMZ::plugins/systemd

zinit ice svn lucid
zinit snippet OMZ::plugins/tig

zinit ice svn lucid
zinit snippet OMZ::plugins/tmux

zinit ice svn lucid
zinit snippet OMZ::plugins/ubuntu

zinit ice svn lucid
zinit snippet OMZ::plugins/ufw

zinit ice svn lucid
zinit snippet OMZ::plugins/virtualenv

zinit ice svn lucid
zinit snippet OMZ::plugins/vscode

zinit ice svn lucid
zinit snippet OMZ::plugins/yarn

zinit ice atload'_zsh_autosuggest_start' lucid
zinit light zsh-users/zsh-autosuggestions

zinit light hlissner/zsh-autopair

zinit ice lucid
zinit light zdharma/fast-syntax-highlighting

zinit ice lucid
zinit light lukechilds/zsh-better-npm-completion

# zinit light Aloxaf/fzf-tab

if type luajit &>/dev/null; then
    ZLUA_EXEC=$(which luajit)
fi
export _ZL_MATCH_MODE=1
export _ZL_ADD_ONCE=1
zinit light skywind3000/z.lua

zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" lucid
zinit load trapd00r/LS_COLORS

# if [[ $(uname -s) = 'Darwin' ]]; then
#     zinit ice cloneonly atclone'ln -fs $PWD/src/dir_colors ~/.dir_colors' atload'test -r ~/.dir_colors && eval $(gdircolors ~/.dir_colors)' lucid
# else
#     zinit ice cloneonly atclone'ln -fs $PWD/src/dir_colors ~/.dir_colors' atload'test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)' lucid
# fi
# zinit light arcticicestudio/nord-dircolors

zinit ice lucid atload"zicompinit; zicdreplay;" blockf
zinit light zsh-users/zsh-completions

unalias fd
alias -s c=$EDITOR
alias -s conf=$EDITOR
alias -s h=$EDITOR
alias -s cc=$EDITOR
alias -s hh=$EDITOR
alias -s cpp=$EDITOR
alias -s hpp=$EDITOR
alias -s cxx=$EDITOR
alias -s hxx=$EDITOR
alias -s txt=$EDITOR
alias -s rs=$EDITOR
alias -s vim=$EDITOR

setopt BANG_HIST                # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS         # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS     # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS        # Do not display a line previously found.
setopt HIST_IGNORE_SPACE        # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS        # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY              # Don't execute immediately upon history expansion.

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

source "$BRGLNG_DOTFILES_DIR/shell_rc_post.sh"

# vim: ts=8 sts=4 sw=4 et
