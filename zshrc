# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source "$BRGLNG_DOTFILES_DIR/shell_rc_pre.sh"

if [[ $HOMEBREW_PREFIX != "" ]]; then
    FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
fi

if [[ ! -e ~/.zgen ]]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

DISABLE_AUTO_UPDATE="true"

if type luajit &>/dev/null; then
    ZLUA_EXEC=$(which luajit)
fi
export _ZL_MATCH_MODE=1
export _ZL_ADD_ONCE=1

ZSH_DISABLE_COMPFIX="true"

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then
    # specify plugins here
    zgen oh-my-zsh

    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/adb
    zgen oh-my-zsh plugins/autopep8
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/cargo
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/colorize
    zgen oh-my-zsh plugins/colored-man-pages
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/docker-compose
    zgen oh-my-zsh plugins/emacs
    zgen oh-my-zsh plugins/emoji
    zgen oh-my-zsh plugins/fd
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/git-flow
    zgen oh-my-zsh plugins/github
    zgen oh-my-zsh plugins/gitignore
    zgen oh-my-zsh plugins/gnu-utils
    zgen oh-my-zsh plugins/golang
    zgen oh-my-zsh plugins/gradle
    zgen oh-my-zsh plugins/mercurial
    zgen oh-my-zsh plugins/man
    zgen oh-my-zsh plugins/mvn
    zgen oh-my-zsh plugins/node
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/nvm
    zgen oh-my-zsh plugins/osx
    zgen oh-my-zsh plugins/perl
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/pipenv
    zgen oh-my-zsh plugins/pylint
    zgen oh-my-zsh plugins/python
    zgen oh-my-zsh plugins/redis-cli
    zgen oh-my-zsh plugins/repo
    zgen oh-my-zsh plugins/ripgrep
    zgen oh-my-zsh plugins/rsync
    zgen oh-my-zsh plugins/ruby
    zgen oh-my-zsh plugins/rust
    zgen oh-my-zsh plugins/rustup
    # zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/supervisor
    zgen oh-my-zsh plugins/svn
    zgen oh-my-zsh plugins/systemd
    zgen oh-my-zsh plugins/tig
    zgen oh-my-zsh plugins/tmux
    zgen oh-my-zsh plugins/ubuntu
    zgen oh-my-zsh plugins/ufw
    zgen oh-my-zsh plugins/virtualenv
    zgen oh-my-zsh plugins/vscode
    zgen oh-my-zsh plugins/yarn

    zgen load romkatv/powerlevel10k powerlevel10k
    zgen load zsh-users/zsh-autosuggestions
    zgen load hlissner/zsh-autopair
    zgen load zdharma/fast-syntax-highlighting
    zgen load lukechilds/zsh-better-npm-completion
    # zgen load Aloxaf/fzf-tab

    zgen load skywind3000/z.lua

    zgen load zsh-users/zsh-completions src

    # generate the init script from plugins above
    zgen save
fi

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

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_environment
add-zsh-hook preexec update_environment

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

source "$BRGLNG_DOTFILES_DIR/shell_rc_post.sh"

# vim: ts=8 sts=4 sw=4 et
