# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

_readlinkf() { perl -MCwd -le 'print Cwd::abs_path shift' "$1";}

source "$(dirname $(_readlinkf ${(%):-%N}))/init_pre.sh"

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

alias shopt=':'

source $HOME/.local/share/zsh/antigen.zsh

antigen use oh-my-zsh

antigen bundle brew
antigen bundle command-not-found
antigen bundle common-aliases
antigen bundle colorize
antigen bundle docker
antigen bundle gem
antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle github
antigen bundle gradle
antigen bundle mercurial
antigen bundle node
antigen bundle npm
antigen bundle perl
antigen bundle pip
antigen bundle pyenv
antigen bundle pylint
antigen bundle python
antigen bundle redis-cli
antigen bundle repo
antigen bundle ruby
antigen bundle osx
antigen bundle tmux

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
#antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zdharma/fast-syntax-highlighting

ZLUA_EXEC=$(which luajit)
export _ZL_MATCH_MODE=1
export _ZL_ADD_ONCE=1
antigen bundle skywind3000/z.lua

POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir dir_writable virtualenv anaconda rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER="…"
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_first_and_last"
antigen theme romkatv/powerlevel10k

antigen apply

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root line)

# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=24'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

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
# setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS         # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS     # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS        # Do not display a line previously found.
setopt HIST_IGNORE_SPACE        # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS        # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY              # Don't execute immediately upon history expansion.

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source "$(dirname $(_readlinkf ${(%):-%N}))/init_post.sh"

# vim: ts=8 sts=4 sw=4 et
