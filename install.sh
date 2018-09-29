#!/bin/sh
set -e

install_yum() {
  :
}

install_apt() {
  sudo apt install -y build-essential g++ gdb clang automake autoconf libtool pkg-config make cmake git global exuberant-ctags silversearcher-ag python3-pip python3-dev vim-gtk3 zsh tmux autojump neovim luajit libluajit-5.1-dev ruby-dev
}

install_linux() {
  distname=$(cat /etc/*release | sed -ne 's/DISTRIB_ID=\(.*\)/\1/gp')
  distver=$(cat /etc/*release | sed -ne 's/DISTRIB_RELEASE=\(.*\)/\1/gp')
  machine=$(uname -m)

  sudo add-apt-repository ppa:neovim-ppa/stable
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
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install coreutils make automake autoconf libtool pkg-config make cmake global ag python python3 tmux autojump luajit reattach-to-user-namespace
  brew install --HEAD universal-ctags/universal-ctags/universal-ctags
  brew install vim --with-override-system-vi --with-gettext --with-python3 --with-luajit
  brew install neovim --with-luajit --with-python3
  brew cask install macvim
}

./link.sh

case $(uname -s) in
  Linux) install_linux ;;
  Darwin) install_mac ;;
esac

mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p ~/.local/share/zsh
curl -L git.io/antigen > ~/.local/share/zsh/antigen.zsh

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/dein-installer.sh
sh /tmp/dein-installer.sh ~/.local/share/dein

# mkdir -p ~/.local/src
# git clone -b stable https://github.com/rust-lang/rust.git ~/.local/src/rust
