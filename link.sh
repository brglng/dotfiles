#!/usr/bin/env bash

update_bashrc() {
    mkdir -p /tmp/$USER/brglng/dotfiles
    cat << EOF > /tmp/$USER/brglng/dotfiles/bashrc
# BEGIN brglng/dotfiles
[ -r $(pwd)/bashrc ] && . $(pwd)/bashrc
# END brglng/dotfiles
EOF

    if [ ! -e $1 ] || [ "$(perl -n0e 'print $1 if /(# BEGIN brglng\/dotfiles.*# END brglng\/dotfiles)/s' $1)" = "" ]; then
      	cat /tmp/$USER/brglng/dotfiles/bashrc >> $1
    else
      	perl -i -p0e 's/# BEGIN brglng\/dotfiles.*# END brglng\/dotfiles.*$/`cat \/tmp\/$ENV{USER}\/brglng\/dotfiles\/bashrc`/gse' $1
    fi
}

update_gitconfig() {
    mkdir -p /tmp/$USER/brglng/dotfiles
    cat << EOF > /tmp/$USER/brglng/dotfiles/gitconfig
# BEGIN brglng/dotfiles
[include]
	path = $(pwd)/gitconfig
# END brglng/dotfiles
EOF

    if [ ! -e $HOME/.gitconfig ] || [ "$(perl -n0e 'print $1 if /(# BEGIN brglng\/dotfiles.*# END brglng\/dotfiles)/s' $HOME/.gitconfig)" = "" ]; then
        cat /tmp/$USER/brglng/dotfiles/gitconfig >> ~/.gitconfig
    else
        perl -i -p0e 's/# BEGIN brglng\/dotfiles.*# END brglng\/dotfiles.*$/`cat \/tmp\/$ENV{USER}\/brglng\/dotfiles\/gitconfig`/gse' $HOME/.gitconfig
    fi
}

update_zshrc() {
    mkdir -p /tmp/$USER/brglng/dotfiles
    cat << EOF > /tmp/$USER/brglng/dotfiles/zshrc
# BEGIN brglng/dotfiles
[ -r $(pwd)/zshrc ] && . $(pwd)/zshrc
# END brglng/dotfiles
EOF

    if [ ! -e $HOME/.zshrc ] || [ "$(perl -n0e 'print $1 if /(# BEGIN brglng\/dotfiles.*# END brglng\/dotfiles)/s' $1)" = "" ]; then
        cat /tmp/$USER/brglng/dotfiles/zshrc >> $HOME/.zshrc
    else
        perl -i -p0e 's/# BEGIN brglng\/dotfiles.*# END brglng\/dotfiles.*$/`cat \/tmp\/$ENV{USER}\/brglng\/dotfiles\/zshrc`/gse' $1
    fi
}

link() {
    mkdir -p ~/.config/alacritty
    [ -e ~/.config/alacritty/alacritty.yml ] && [ ! -L ~/.config/alacritty/alacritty.yml ] && mv -f ~/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml.orig
    ln -fs $(pwd)/config/alacritty/alacritty.yml ~/.config/alacritty/

    update_bashrc $HOME/.bashrc

    mkdir -p ~/.cgdb
    [ -e ~/.cgdb/cgdbrc ] && [ ! -L ~/.cgdb/cgdbrc ] && mv -f ~/.cgdb/cgdbrc ~/.cgdb/cgdbrc.orig
    ln -fs $(pwd)/cgdb/cgdbrc ~/.cgdb/

    [ -e ~/.gitignore_global ] && [ ! -L ~/.gitignore_global ] && mv -f ~/.gitignore_global ~/.gitignore_global.orig
    ln -fs $(pwd)/gitignore_global ~/.gitignore_global

    [ -e ~/.tmux.conf ] && [ ! -L ~/.tmux.conf ] && mv -f ~/.tmux.conf ~/.tmux.conf.orig
    ln -fs $(pwd)/tmux.conf ~/.tmux.conf

    [ -e ~/.vimrc ] && [ ! -L ~/.vimrc ] && mv -f ~/.vimrc ~/.vimrc.orig
    ln -fs $(pwd)/vimrc ~/.vimrc

    [ -e ~/.vim ] && [ ! -L ~/.vim ] && mv -f ~/.vim ~/.vim.orig
    ln -fs $(pwd)/vim ~/.vim

    mkdir -p ~/.config/nvim
    [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ] && mv -f ~/.config/nvim ~/.config/nvim.orig
    ln -fs $(pwd)/vim ~/.config/nvim

    update_gitconfig
    update_zshrc

    mkdir -p ~/.local/bin
    ln -fs $(pwd)/local/bin/* ~/.local/bin/
}

link_linux() {
    link
}

link_mac() {
    link
    update_bashrc $HOME/.bash_profile
}

case $(uname -s) in
    Linux) link_linux ;;
    Darwin) link_mac ;;
esac

# vim: ts=8 sts=4 sw=4 et
