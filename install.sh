#!/usr/bin/env bash
set -e

function linux_brew() {
    PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" /home/linuxbrew/.linuxbrew/bin/brew "$@"
}

function install_yum() {
    echo "Not implemented yet!"
    exit -1
}

function install_apt() {
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
    sudo apt-get update
    sudo apt-get install -y build-essential g++ gdb automake autoconf libtool pkg-config make git luajit libluajit-5.1-dev ruby-dev zlib1g-dev libncurses-dev xsel
}

function install_linux() {
    distname=$(cat /etc/*release | sed -ne 's/DISTRIB_ID=\(.*\)/\1/gp')
    distver=$(cat /etc/*release | sed -ne 's/DISTRIB_RELEASE=\(.*\)/\1/gp')
    machine=$(uname -m)

    case $distname in
      	Ubuntu) install_apt ;;
      	Debian) install_apt ;;
      	Fedora) install_yum ;;
      	CentOS) install_yum ;;
    esac

    git config --global http.postBuffer 524288000

    # Install Homebrew for Linux
    if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
      	linux_brew update
    else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    fi

    linux_brew install cmake tmux ccls fzf ripgrep-all clang-format fd vim colordiff exa fselect fx nnn tig glances

    if ! linux_brew ls --versions neovim > /dev/null; then
      	linux_brew install --HEAD neovim
    fi

    if ! linux_brew ls --versions universal-ctags; then
      	linux_brew tap universal-ctags/universal-ctags
      	linux_brew install --HEAD universal-ctags
    fi

    $(linux_brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

    mkdir -p $HOME/.local/bin
    ln -fs $(linux_brew --prefix)/bin/cmake	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/tmux	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/ccls	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/rg	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/clang-format  $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/fd	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/vim	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/colordiff	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/exa	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/fselect	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/fx	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/nnn	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/tig	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/glances	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/nvim	    $HOME/.local/bin/
    ln -fs $(linux_brew --prefix)/bin/ctags	    $HOME/.local/bin/
}

function install_mac() {
    if which brew > /dev/null; then
      	brew update
    else
      	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    git config --global http.postBuffer 524288000

    brew install coreutils gnu-sed gawk make automake autoconf libtool pkg-config cmake tmux luajit ccls fzf ripgrep-all clang-format fd vim colordiff exa fselect fx nnn tig glances
    # brew install reattach-to-user-namespace

    if ! brew ls --versions neovim > /dev/null; then
      	brew install --HEAD neovim
    fi

    if ! brew ls --versions universal-ctags; then
      	brew tap universal-ctags/universal-ctags
      	brew install --HEAD universal-ctags
    fi

    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

    brew cask install macvim alacritty
}

while true; do
    read -p "Have you set up your Python 3 environment yet? (y/n) " yn
    case $yn in
        [Yy]* )
	    echo "OK, let's go on...";
	    break
	    ;;
        [Nn]* )
	    echo "Please set up your Python 3 environment before running this script."
	    exit -1
	    ;;
        * ) echo "Please answer yes or no.";;
    esac
done

export PATH=$HOME/.local/bin:$PATH
export HOMEBREW_NO_AUTO_UPDATE=1

case $(uname -s) in
    Linux) install_linux ;;
    Darwin) install_mac ;;
esac

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install node npm
nvm use node
nvm alias default node

python3 -m pip install --user -U pynvim neovim autopep8 pylint jedi

sudo -H gem install neovim
npm install -g neovim

mkdir -p ~/.tmux/plugins
if [ -e ~/.tmux/plugins/tpm ]; then
    pushd ~/.tmux/plugins/tpm
    git pull
    popd
else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

mkdir -p ~/.local/share/zsh
curl -L git.io/antigen > ~/.local/share/zsh/antigen.zsh

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s -- ~/.cache/dein

./link.sh

echo "Congratulations! Installation is finished. It is strongly recommended that you log out from your current shell and log in again now immediately."
