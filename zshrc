autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

alias shopt=':'

source ~/.bashrc

if [ $(uname -s) = Darwin ]; then
  source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ruby autojump mvn gradle)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

if [ -e /usr/local/share/autojump/autojump.zsh ]; then
  source /usr/local/share/autojump/autojump.zsh
elif [ -e /usr/share/autojump/autojump.zsh ]; then
  source /usr/share/autojump/autojump.zsh
fi

. ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

powerline-daemon -q
if [ $(uname -s) = Darwin ]; then
  source ~/Library/Python/3.6/lib/python/site-packages/powerline/bindings/zsh/powerline.zsh
else
  if [ -e ~/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh ]; then
    . ~/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh
  elif [ -e ~/.local/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh ]; then
    . ~/.local/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh
  elif [ -e /usr/local/lib/python3.5/dist-packages/powerline/bindings/zsh/powerline.zsh ]; then
    . /usr/local/lib/python3.5/dist-packages/powerline/bindings/zsh/powerline.zsh
  elif [ -e ~/.local/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh ]; then
    . ~/.local/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh
  elif [ -e /usr/local/lib/python3.4/dist-packages/powerline/bindings/zsh/powerline.zsh ]; then
    . /usr/local/lib/python3.4/dist-packages/powerline/bindings/zsh/powerline.zsh
  fi
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [ $(uname -s) = Darwin ]; then
  alias ls="/usr/local/bin/gls --group-directories-first -F -h --color"
else
  alias ls="ls --group-directories-first -F -h --color"
fi
alias vi=vim

alias -s c=vim
alias -s h=vim
alias -s cc=vim
alias -s hh=vim
alias -s cpp=vim
alias -s hpp=vim
alias -s cxx=vim
alias -s hxx=vim
alias -s java=vim
alias -s txt=vim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
