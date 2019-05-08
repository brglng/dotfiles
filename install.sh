#!/bin/sh
set -e

install_yum() {
  :
}

install_apt() {
  sudo apt install -y build-essential g++ gdb clang automake autoconf libtool pkg-config make cmake git global exuberant-ctags ripgrep python3-pip python3-dev vim-gtk3 zsh tmux neovim luajit libluajit-5.1-dev ruby-dev
}

install_linux() {
  distname=$(cat /etc/*release | sed -ne 's/DISTRIB_ID=\(.*\)/\1/gp')
  distver=$(cat /etc/*release | sed -ne 's/DISTRIB_RELEASE=\(.*\)/\1/gp')
  machine=$(uname -m)

  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update

  case $(distname) in
    Ubuntu) install_apt ;;
    Debian) install_apt ;;
    Fedora) install_yum ;;
    CentOS) install_yum ;;
  esac

  sudo -H pip3 install neovim
  # sudo -H pip3 install powerline-status
  sudo gem install neovim
}

install_mac() {
  if [[ ! -e /usr/local/bin/brew ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    brew update
  fi
  brew install coreutils make automake autoconf libtool pkg-config make cmake ctags global ripgrep sk python python3 tmux luajit reattach-to-user-namespace
  brew install vim --with-override-system-vi --with-gettext --with-python3 --with-luajit
  brew install neovim --HEAD
  brew cask install macvim
}

./link.sh

case $(uname -s) in
  Linux) install_linux ;;
  Darwin) install_mac ;;
esac

mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/dein-installer.sh
sh /tmp/dein-installer.sh ~/.cache/dein

mkdir -p ~/.local/share/zsh
curl -L git.io/antigen > ~/.local/share/zsh/antigen.zsh

zsh -c 'source ~/.zshrc && antigen update'

nvim +UpdateRemotePlugins +qall

# mkdir -p ~/.local/src
# git clone -b stable https://github.com/rust-lang/rust.git ~/.local/src/rust
