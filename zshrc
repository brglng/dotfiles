# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source "$BRGLNG_DOTFILES_DIR/shell_rc_pre.sh"

if [[ $HOMEBREW_PREFIX != "" ]]; then
    FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
fi

ZSH_DISABLE_COMPFIX="true"

zstyle ':zim:zmodule' use 'degit'
ZIM_HOME=~/.zim

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

bindkey -e

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

if type starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

if type direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

if type carapace &>/dev/null; then
    export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
    # zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    source <(carapace _carapace)
fi

if [[ -e $(brew --prefix)/share/z.lua/z.lua ]]; then
    if type luajit &>/dev/null; then
        ZLUA_EXEC=$(which luajit)
    fi
    export _ZL_MATCH_MODE=1
    export _ZL_ADD_ONCE=1
    export _ZL_ZSH_NO_FZF=1
    eval "$(lua $(brew --prefix z.lua)/share/z.lua/z.lua --init zsh)"
fi

# if type zoxide &>/dev/null; then
#     eval "$(zoxide init zsh)"
# fi

source "$BRGLNG_DOTFILES_DIR/shell_rc_post.sh"

# vim: ts=8 sts=4 sw=4 et
