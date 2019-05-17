#!/usr/bin/env bash

link() {
  mkdir -p ~/.config/alacritty
  [ ! -L ~/.config/alacritty/alacritty.yml ] && mv -f ~/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml.orig
  ln -fs $(pwd)/config/alacritty/alacritty.yml ~/.config/alacritty/

  [ ! -L ~/.bashrc ] && mv -f ~/.bashrc ~/.bashrc.orig
  ln -fs $(pwd)/bashrc ~/.bashrc

  mkdir -p ~/.cgdb
  [ ! -L ~/.cgdb/cgdbrc ] && mv -f ~/.cgdb/cgdbrc ~/.cgdb/cgdbrc.orig
  ln -fs $(pwd)/cgdb/cgdbrc ~/.cgdb/

  [ ! -L ~/.gitignore_global ] && mv -f ~/.gitignore_global ~/.gitignore_global.orig
  ln -fs $(pwd)/gitignore_global ~/.gitignore_global

  [ ! -L ~/.tmux.conf ] && mv -f ~/.tmux.conf ~/.tmux.conf.orig
  ln -fs $(pwd)/tmux.conf ~/.tmux.conf

  mkdir -p ~/.config
  if [ -L ~/.config/nvim ]; then
    rm -f ~/.config/nvim
  else
    mv -f ~/.config/nvim ~/.config/nvim.orig
  fi
  ln -s $(pwd)/vim ~/.config/nvim

  if [ -L ~/.vim ]; then
    rm -f ~/.vim
  else
    mv -f ~/.vim ~/.vim.orig
  fi
  ln -s $(pwd)/vim ~/.vim

  [ ! -L ~/.vimrc ] && mv -f ~/.vimrc ~/.vimrc.orig
  ln -fs $(pwd)/vimrc ~/.vimrc

  [ ! -L ~/.zshrc ] && mv -f ~/.zshrc ~/.zshrc.orig
  ln -fs $(pwd)/zshrc ~/.zshrc

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
    perl -i -p0e 's/# begin brglng\/dotfiles.*# end brglng\/dotfiles/`cat \/tmp\/brglng\/dotfiles\/bash_profile`/gse' $HOME/.bash_profile
  fi
}

case $(uname -s) in
  Linux) link_linux ;;
  Darwin) link_mac ;;
esac

rm -rf ~/.cache/dein/state*.vim
