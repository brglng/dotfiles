#!/bin/sh

link() {
  ln -fs `pwd`/bashrc              ~/.bashrc
  mkdir -p ~/.cgdb
  ln -fs `pwd`/cgdb/cgdbrc         ~/.cgdb/
  mkdir -p ~/.config
  ln -fs `pwd`/config/oni          ~/.config/
  ln -fs `pwd`/gitignore_global    ~/.gitignore_global
  ln -fs `pwd`/oh-my-zsh           ~/.oh-my-zsh
  # ln -fs `pwd`/pentadactylrc       ~/.pentadactylrc
  ln -fs `pwd`/tmux.conf           ~/.tmux.conf
  ln -fs `pwd`/vimrc               ~/.vimrc
  ln -fs `pwd`/vim                 ~/.vim
  ln -fs `pwd`/vim                 ~/.config/nvim
  ln -fs `pwd`/zshrc               ~/.zshrc

  if [ "`perl -n0e 'print $1 if /(# begin brglng\/dotfiles.*# end brglng\/dotfiles)/s'`" = "" ]; then
  cat << EOF >> ~/.gitconfig
# begin brglng/dotfiles
[include]
	path = `pwd`/gitconfig
# end brglng/dotfiles
EOF
  else
    gitignore_str=`cat << EOF
# begin brglng\\/dotfiles
[include]
	path = `pwd`\\/gitconfig
# end brglng\\/dotfiles
EOF`
    perl -ip0e "s/(# begin brglng\\/dotfiles.*# end brglng\\/dotfiles)/$gitignore_str/g" ~/.gitconfig
  fi

  mkdir -p ~/.local/bin
  ln -fs `pwd`/local/bin/* ~/.local/bin/
}

link_linux() {
  link
  # mkdir -p ~/.config/fontconfig
  # ln -s $(pwd)/config/fontconfig/fonts.conf.$distname.$distver   ~/.config/fontconfig/fonts.conf
}

link_mac() {
  link

  if [ "`perl -n0e 'print $1 if /(# begin brglng\/dotfiles.*# end brglng\/dotfiles)/s'`" = "" ]; then
  cat << EOF >> ~/.gitconfig
# begin brglng/dotfiles
[[ -r ~/.bashrc ]] && . ~/.bashrc
# end brglng/dotfiles
EOF
  else
    bash_profile_str=`cat << EOF
# begin brglng\\/dotfiles
[[ -r ~\\/.bashrc ]] && . ~\\/.bashrc
# end brglng\\/dotfiles
EOF`
    perl -ip0e "s/(# begin brglng\\/dotfiles.*# end brglng\\/dotfiles)/$bash_profile_str/g" ~/.bash_profile
  fi
}

case `uname -s` in
  Linux) link_linux ;;
  Darwin) link_mac ;;
esac

rm -rf ~/.cache/dein/state*.vim
