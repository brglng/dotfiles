#!/bin/sh

link() {
  ln -s $(pwd)/.bashrc                                            ~/.bashrc
  mkdir -p ~/.cgdb
  ln -s $(pwd)/.cgdb/cgdbrc                                       ~/.cgdb/
  mkdir -p ~/.config
  ln -s $(pwd)/.config/powerline                                  ~/.config/
  ln -s $(pwd)/.gitconfig                                         ~/.gitconfig
  ln -s $(pwd)/.gitignore_global                                  ~/.gitignore_global
  ln -s $(pwd)/.oh-my-zsh                                         ~/.oh-my-zsh
  ln -s $(pwd)/.pentadactylrc                                     ~/.pentadactylrc
  ln -s $(pwd)/.tmux.conf                                         ~/.tmux.conf
  ln -s $(pwd)/.tmux.conf.d                                       ~/.tmux.conf.d
  ln -s $(pwd)/.vimrc                                             ~/.vimrc
  ln -s $(pwd)/.vim                                               ~/.vim
  ln -s $(pwd)/.vim                                               ~/.config/nvim
  ln -s $(pwd)/.zshrc                                             ~/.zshrc
}

link_linux() {
  link
  mkdir -p ~/.config/fontconfig
  ln -s $(pwd)/.config/fontconfig/fonts.conf.$distname.$distver   ~/.config/fontconfig/fonts.conf
}

link_mac() {
  link
  mkdir -p ~/Library/Python/2.7/lib/python/site-packages
  echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> ~/Library/Python/2.7/lib/python/site-packages/homebrew.pth
  echo '[[ -r ~/.bashrc ]] && . ~/.bashrc' >> ~/.bash_profile
}

case $(uname -s) in
  Linux) link_linux ;;
  Darwin) link_mac ;;
esac
