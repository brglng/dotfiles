#!/bin/sh

link() {
  ln -fs $(pwd)/bashrc              ~/.bashrc
  mkdir -p ~/.cgdb
  ln -fs $(pwd)/cgdb/cgdbrc         ~/.cgdb/
  mkdir -p ~/.config
  ln -fs $(pwd)/config/oni          ~/.config/
  ln -fs $(pwd)/gitignore_global    ~/.gitignore_global
  ln -fs $(pwd)/oh-my-zsh           ~/.oh-my-zsh
  # ln -fs $(pwd)/pentadactylrc       ~/.pentadactylrc
  ln -fs $(pwd)/tmux.conf           ~/.tmux.conf
  ln -fs $(pwd)/vimrc               ~/.vimrc
  ln -fs $(pwd)/vim                 ~/.vim
  ln -fs $(pwd)/vim                 ~/.config/nvim
  ln -fs $(pwd)/zshrc               ~/.zshrc

  sed '/# begin brglng\/dotfiles/,/# end brglng\/dotfiles/d' ~/.gitconfig > ~/.gitconfig
  cat << EOF >> ~/.gitconfig
# begin brglng/dotfiles
[include]
	path = $(pwd)/gitconfig
# end brglng/dotfiles
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

  sed '/# begin brglng\/dotfiles/,/# end brglng\/dotfiles/d' ~/.bash_profile > ~/.bash_profile
  cat << EOF >> ~/.bash_profile
# begin brglng/dotfiles
echo '[[ -r ~/.bashrc ]] && . ~/.bashrc'
# end brglng/dotfiles
EOF
}

case $(uname -s) in
  Linux) link_linux ;;
  Darwin) link_mac ;;
esac
