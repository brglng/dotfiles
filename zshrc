# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [[ `uname -s` = Darwin ]]; then
    readlinkf() { greadlink -f "$1"; }
else
    readlinkf() { readlink -f "$1"; }
fi

source "$(dirname $(readlinkf ${(%):-%N}))/shell_rc_pre.sh"

if [[ $HOMEBREW_PREFIX != "" ]]; then
    FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
fi

source ~/.zinit/bin/zinit.zsh

# most themes use this option
setopt promptsubst

# common OMZ libraries
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/git.zsh
# zinit snippet OMZ::lib/theme-and-appearance.zsh

# some OMZ themes use this plugin
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit atload'!source ~/.p10k.zsh' lucid nocd
zinit light romkatv/powerlevel10k

zinit ice as"completion" wait=3 lucid
zinit snippet OMZ::plugins/adb/_adb

zinit ice as"completion"
zinit snippet OMZ::plugins/autopep8/_autopep8

zinit ice wait lucid
zinit snippet OMZ::plugins/brew/brew.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/cargo/_cargo

zinit ice wait lucid
zinit snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

zinit snippet OMZ::plugins/common-aliases/common-aliases.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/colorize/colorize.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

zinit ice as"completion" wait=1 lucid
zinit snippet OMZ::plugins/docker/_docker

zinit ice as"completion" wait=1 lucid
zinit snippet OMZ::plugins/docker-compose/_docker-compose

zinit ice wait lucid
zinit snippet OMZ::plugins/docker-compose/docker-compose.plugin.zsh

zinit ice svn wait lucid
zinit snippet OMZ::plugins/emoji

zinit ice as"completion"
zinit snippet OMZ::plugins/fd/_fd

zinit ice as"completion"
zinit snippet OMZ::plugins/gem/_gem

zinit ice wait=2 lucid
zinit snippet OMZ::plugins/gem/gem.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/git-flow/git-flow.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/github/_hub

zinit ice wait lucid
zinit snippet OMZ::plugins/github/github.plugin.zsh

zinit ice wait=2 lucid
zinit snippet OMZ::plugins/gitignore/gitignore.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/gnu-utils/gnu-utils.plugin.zsh

zinit ice svn wait lucid
zinit snippet OMZ::plugins/golang

zinit ice as"completion"
zinit snippet OMZ::plugins/gradle/_gradle

zinit ice as"completion"
zinit snippet OMZ::plugins/gradle/_gradlew

zinit ice wait lucid wait=3 lucid
zinit snippet OMZ::plugins/gradle/gradle.plugin.zsh

zinit ice wait=1 lucid
zinit snippet OMZ::plugins/mercurial/mercurial.plugin.zsh

zinit ice wait=3 lucid
zinit snippet OMZ::plugins/mvn/mvn.plugin.zsh

zinit ice wait=1 lucid
zinit snippet OMZ::plugins/node/node.plugin.zsh

zinit ice wait=1 lucid
zinit snippet OMZ::plugins/npm/npm.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/nvm/_nvm

zinit ice wait=1 lucid
zinit snippet OMZ::plugins/nvm/nvm.plugin.zsh

zinit ice svn wait lucid
zinit snippet OMZ::plugins/osx

zinit ice wait lucid
zinit snippet OMZ::plugins/perl/perl.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/pip/_pip

zinit ice wait lucid
zinit snippet OMZ::plugins/pip/pip.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/pipenv/pipenv.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/pyenv/pyenv.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/pylint/_pylint

zinit ice wait lucid
zinit snippet OMZ::plugins/pylint/pylint.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/python/python.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/redis-cli/_redis-cli

zinit ice as"completion"
zinit snippet OMZ::plugins/repo/_repo

zinit ice wait lucid wait=3 lucid
zinit snippet OMZ::plugins/repo/repo.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/ripgrep/_ripgrep

zinit ice wait lucid wait lucid
zinit snippet OMZ::plugins/rsync/rsync.plugin.zsh

zinit ice wait lucid wait=2 lucid
zinit snippet OMZ::plugins/ruby/ruby.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/rust/_rust

zinit ice svn wait lucid
zinit snippet OMZ::plugins/tmux

zinit ice wait lucid
zinit snippet OMZ::plugins/ubuntu/ubuntu.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/ufw/_ufw

zinit ice wait lucid
zinit snippet OMZ::plugins/virtualenv/virtualenv.plugin.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/vscode/vscode.plugin.zsh

zinit ice wait=1 atload'_zsh_autosuggest_start' lucid
zinit light zsh-users/zsh-autosuggestions

zinit light hlissner/zsh-autopair

zinit ice wait=1 lucid
zinit light zdharma/fast-syntax-highlighting

zinit ice wait=1 lucid
zinit light lukechilds/zsh-better-npm-completion

if type luajit &>/dev/null; then
    ZLUA_EXEC=$(which luajit)
fi
export _ZL_MATCH_MODE=1
export _ZL_ADD_ONCE=1
zinit light skywind3000/z.lua

zplugin ice wait atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" lucid
zplugin load trapd00r/LS_COLORS

zinit wait lucid atload"zicompinit; zicdreplay;" blockf for zsh-users/zsh-completions

unalias fd
alias -s c=$EDITOR
alias -s h=$EDITOR
alias -s cc=$EDITOR
alias -s hh=$EDITOR
alias -s cpp=$EDITOR
alias -s hpp=$EDITOR
alias -s cxx=$EDITOR
alias -s hxx=$EDITOR
alias -s java=$EDITOR
alias -s txt=$EDITOR

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

if type powerline-daemon &>/dev/null; then
    powerline-daemon -q
fi

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

source "$(dirname $(readlinkf ${(%):-%N}))/shell_rc_post.sh"

# vim: ts=8 sts=4 sw=4 et
