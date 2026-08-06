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

function update_zprofile {
    update_file "$HOME/.zprofile" \
        '#[ \t]*BEGIN[ \t]*brglng\/dotfiles' \
        '#[ \t]*END[ \t]*brglng\/dotfiles' \
        "$(cat << EOF
# BEGIN brglng/dotfiles
export BRGLNG_DOTFILES_DIR=$PWD
[[ -r "\$BRGLNG_DOTFILES_DIR/zprofile" ]] && . "\$BRGLNG_DOTFILES_DIR/zprofile"
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

function update_alacritty_toml {
    mkdir -p "$HOME/.config/alacritty"
    update_file "$HOME/.config/alacritty/alacritty.toml" \
        '#[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '#[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
# BEGIN brglng/dotfiles
import = [
    $PWD/config/alacritty/alacritty.toml
]
# END brglng/dotfiles
EOF
)"
}

function update_kitty_conf {
    mkdir -p "$HOME/.config/kitty"
    update_file "$HOME/.config/kitty/kitty.conf" \
        '#[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '#[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
# BEGIN brglng/dotfiles
include $PWD/config/kitty/kitty.conf
# END brglng/dotfiles
EOF
)"
}

function update_vimrc {
    update_file "$HOME/.vimrc" \
        '"[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '"[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
" BEGIN brglng/dotfiles
source $PWD/config/nvim/init.vim
" END brglng/dotfiles
EOF
)"
}

function update_gvimrc {
    update_file "$HOME/.gvimrc" \
        '"[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '"[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
" BEGIN brglng/dotfiles
source $PWD/config/nvim/ginit.vim
" END brglng/dotfiles
EOF
)"
}

function update_nvim_init_vim {
    update_file "$HOME/.config/nvim/init.vim" \
        '"[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '"[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
" BEGIN brglng/dotfiles
let $BRGLNG_DOTFILES_DIR = '$PWD'
source $PWD/config/nvim/init.vim
" END brglng/dotfiles
EOF
)"
}

function update_nvim_ginit_vim {
    update_file "$HOME/.config/nvim/ginit.vim" \
        '"[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '"[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
" BEGIN brglng/dotfiles
let $BRGLNG_DOTFILES_DIR = '$PWD'
source $PWD/config/nvim/ginit.vim
" END brglng/dotfiles
EOF
)"
}

function update_nvim_init_lua {
    update_file "$HOME/.config/nvim/lua/init.lua" \
        '--[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '--[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
-- BEGIN brglng/dotfiles
vim.env.BRGLNG_DOTFILES_DIR="$PWD"
dofile(vim.env.BRGLNG_DOTFILES_DIR .. "/config/nvim/init.lua")
-- END brglng/dotfiles
EOF
)"
}

function link_common() {
    link "$PWD/config/neovide"                              "$HOME/.config/neovide"
    link "$PWD/config/powerline"                            "$HOME/.config/powerline"
    link "$PWD/config/starship.toml"                        "$HOME/.config/starship.toml"
    link "$PWD/config/wezterm"                              "$HOME/.config/wezterm"
    link "$PWD/config/tmux"                                 "$HOME/.config/tmux"
    link "$PWD/gitignore_global"                            "$HOME/.gitignore_global"
    link "$PWD/tmux.conf"                                   "$HOME/.tmux.conf"
    link "$PWD/zimrc"                                       "$HOME/.zimrc"
    link "$PWD/config/kitty/themes"                         "$HOME/.config/kitty/themes"
    link "$PWD/config/kitty/dark-theme.auto.conf"           "$HOME/.config/kitty/dark-theme.auto.conf"
    link "$PWD/config/kitty/light-theme.auto.conf"          "$HOME/.config/kitty/light-theme.auto.conf"
    link "$PWD/config/kitty/no-preference-theme.auto.conf"  "$HOME/.config/kitty/no-preference-theme.auto.conf"
    link "$PWD/config/ghostty"                              "$HOME/.config/ghostty"

    update_vimrc
    update_gvimrc
    upddate_nvim_init_lua
    # update_alacritty_toml
    # link "$PWD/config/alacritty/colors"                     "$HOME/config/.alacritty/colors"
    update_gitconfig
    update_kitty_conf
    update_zprofile
    update_zshrc
}

function link_linux() {
    update_bashrc                               "$HOME/.bashrc"
    mkdir -p "$HOME/.config/nushell"
    link "$PWD/config/nushell/env.nu"           "$HOME/.config/nushell/env.nu"
    link "$PWD/config/nushell/config.nu"        "$HOME/.config/nushell/config.nu"
    link_common
}

function link_mac() {
    update_bashrc                               "$HOME/.bash_profile"
    mkdir -p "$HOME/Library/Application Support/nushell"
    link "$PWD/config/nushell/env.nu"           "$HOME/Library/Application Support/nushell/env.nu"
    link "$PWD/config/nushell/config.nu"        "$HOME/Library/Application Support/nushell/config.nu"
    link_common
}

case $(uname -s) in
    Linux) link_linux ;;
    Darwin) link_mac ;;
esac

# vim: ts=8 sts=4 sw=4 et
