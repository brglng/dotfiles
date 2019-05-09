#!/bin/sh

link() {
  ln -fs $(pwd)/bashrc              ~/.bashrc
  mkdir -p ~/.cgdb
  ln -fs $(pwd)/cgdb/cgdbrc         ~/.cgdb/
  mkdir -p ~/.config
  # ln -fs $(pwd)/config/powerline    ~/.config/
  ln -fs $(pwd)/config/oni          ~/.config/
  ln -fs $(pwd)/gitignore_global    ~/.gitignore_global
  ln -fs $(pwd)/oh-my-zsh           ~/.oh-my-zsh
  # ln -fs $(pwd)/pentadactylrc       ~/.pentadactylrc
  ln -fs $(pwd)/tmux.conf           ~/.tmux.conf
  ln -fs $(pwd)/vimrc               ~/.vimrc
  ln -fs $(pwd)/vim                 ~/.vim
  ln -fs $(pwd)/vim                 ~/.config/nvim
  ln -fs $(pwd)/zshrc               ~/.zshrc

  cat << EOF >> ~/.gitconfig
[include]
	path = $(pwd)/gitconfig
EOF

  mkdir -p ~/.local/bin
  ln -fs $(pwd)/local/bin/*         ~/.local/bin/
}

link_linux() {
  link
  # mkdir -p ~/.config/fontconfig
  # ln -s $(pwd)/config/fontconfig/fonts.conf.$distname.$distver   ~/.config/fontconfig/fonts.conf
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
