#!/bin/bash
set -e

source "scripts/util.sh"

function update_bashrc {
    update_file "$1" \
        '#[ \t]*BEGIN[ \t]*brglng\/dotfiles' \
        '#[ \t]*END[ \t]*brglng\/dotfiles' \
        "$(cat << EOF
# BEGIN brglng/dotfiles
export BRGLNG_DOTFILES_DIR=$PWD
[[ -r "\$BRGLNG_DOTFILES_DIR/bashrc" ]] && . "\$BRGLNG_DOTFILES_DIR/bashrc"
# END brglng/dotfiles
EOF
)"
}

function update_zshrc {
    update_file "$HOME/.zshrc" \
        '#[ \t]*BEGIN[ \t]*brglng\/dotfiles' \
        '#[ \t]*END[ \t]*brglng\/dotfiles' \
        "$(cat << EOF
# BEGIN brglng/dotfiles
export BRGLNG_DOTFILES_DIR=$PWD
[[ -r "\$BRGLNG_DOTFILES_DIR/zshrc" ]] && . "\$BRGLNG_DOTFILES_DIR/zshrc"
# END brglng/dotfiles
EOF
)"
}

function update_gitconfig {
    update_file "$HOME/.gitconfig" \
        '#[ \t]*BEGIN[ \t]*brglng\/dotfiles' \
        '#[ \t]*END[ \t]*brglng\/dotfiles' \
        "$(cat << EOF
# BEGIN brglng/dotfiles
[include]
	path = "$PWD/gitconfig"
# END brglng/dotfiles
EOF
)"
}

function link_common() {
    link "$PWD/clang-format"                    "$HOME/.clang-format"
    link "$PWD/config/alacritty/alacritty.yml"  "$HOME/.config/alacritty/alacritty.yml"
    link "$PWD/config/powerline"                "$HOME/.config/powerline"
    link "$PWD/cgdb/cgdbrc"                     "$HOME/.cgdb/cgdbrc"
    update_gitconfig
    link "$PWD/gitignore_global"                "$HOME/.gitignore_global"
    link "$PWD/tmux.conf"                       "$HOME/.tmux.conf"
    link "$PWD/vimrc"                           "$HOME/.vimrc"
    link "$PWD/vim"                             "$HOME/.vim"
    link "$PWD/nvim"                            "$HOME/.config/nvim"
    link "$PWD/zprofile"                        "$HOME/.zprofile"
    update_zshrc
}

function link_linux() {
    update_bashrc                               "$HOME/.bashrc"
    link_common
}

function link_mac() {
    update_bashrc                               "$HOME/.bash_profile"
    link_common
}

case $(uname -s) in
    Linux) link_linux ;;
    Darwin) link_mac ;;
esac

# vim: ts=8 sts=4 sw=4 et
