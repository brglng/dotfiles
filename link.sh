#!/usr/bin/env bash

link() {
  ln -fs $(pwd)/bashrc ~/.bashrc

  mkdir -p ~/.cgdb
  ln -fs $(pwd)/cgdb/cgdbrc ~/.cgdb/

  ln -fs $(pwd)/gitignore_global    ~/.gitignore_global
  ln -fs $(pwd)/tmux.conf           ~/.tmux.conf

  mkdir -p ~/.config
  ln -fs $(pwd)/vim	~/.config/nvim
  ln -fs $(pwd)/vim     ~/.vim
  ln -fs $(pwd)/vimrc   ~/.vimrc

  ln -fs $(pwd)/zshrc               ~/.zshrc

  mkdir -p /tmp/brglng/dotfiles
  cat << EOF > /tmp/brglng/dotfiles/gitconfig
# begin brglng/dotfiles
[include]
	path = $(pwd)/gitconfig
# end brglng/dotfiles
EOF

  if [ ! -e $HOME/.gitconfig ] || [ "$(perl -n0e 'print $1 if /(# begin brglng\/dotfiles.*# end brglng\/dotfiles)/s' $HOME/.gitconfig)" = "" ]; then
    cat /tmp/brglng/dotfiles/gitconfig >> ~/.gitconfig
  else
    perl -i -p0e 's/# begin brglng\/dotfiles.*# end brglng\/dotfiles/`cat \/tmp\/brglng\/dotfiles\/gitconfig`/gse' $HOME/.gitconfig
  fi

  mkdir -p ~/.local/bin
  ln -fs $(pwd)/local/bin/* ~/.local/bin/
}

link_linux() {
  link
}

link_mac() {
  link

  mkdir -p /tmp/brglng/dotfiles
  cat << EOF > /tmp/brglng/dotfiles/bash_profile
# begin brglng/dotfiles
[ -r ~/.bashrc ] && . ~/.bashrc
# end brglng/dotfiles
EOF

  if [ ! -e $HOME/.bash_profile ] || [ "$(perl -n0e 'print $1 if /(# begin brglng\/dotfiles.*# end brglng\/dotfiles)/s' $HOME/.bash_profile)" = "" ]; then
    cat /tmp/brglng/dotfiles/bash_profile >> ~/.bash_profile
  else
    perl -i p0e 's/# begin brglng\/dotfiles.*# end brglng\/dotfiles/`cat \/tmp\/brglng\/dotfiles\/bash_profile`/gse' $HOME/.bash_profile
  fi
}

case $(uname -s) in
  Linux) link_linux ;;
  Darwin) link_mac ;;
esac

rm -rf ~/.cache/dein/state*.vim
