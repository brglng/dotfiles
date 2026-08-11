#!/bin/bash
set -e

source "scripts/util.sh"

function update_bashrc {
    update_file "#" "$1" "$(cat << EOF
export BRGLNG_DOTFILES_DIR=$PWD
[[ -r "\$BRGLNG_DOTFILES_DIR/bashrc" ]] && . "\$BRGLNG_DOTFILES_DIR/bashrc"
EOF
)"
}

function update_zshrc {
    update_file "#" "$HOME/.zshrc" "$(cat << EOF
export BRGLNG_DOTFILES_DIR=$PWD
[[ -r "\$BRGLNG_DOTFILES_DIR/zshrc" ]] && . "\$BRGLNG_DOTFILES_DIR/zshrc"
EOF
)"
}

function update_zprofile {
    update_file "#" "$HOME/.zprofile" "$(cat << EOF
export BRGLNG_DOTFILES_DIR=$PWD
[[ -r "\$BRGLNG_DOTFILES_DIR/zprofile" ]] && . "\$BRGLNG_DOTFILES_DIR/zprofile"
EOF
)"
}

function update_gitconfig {
    update_file "#" "$HOME/.gitconfig" "$(cat << EOF
[include]
	path = "$PWD/gitconfig"
[core]
	excludesfile = "$PWD/gitignore_global"
EOF
)"
}

function update_alacritty_toml {
    mkdir -p "$HOME/.config/alacritty"
    update_file "#" "$HOME/.config/alacritty/alacritty.toml" "$(cat <<EOF
import = [
    $PWD/config/alacritty/alacritty.toml
]
EOF
)"
}

function update_tmux_conf {
    update_file "#" "$1" "$(cat <<EOF
set-environment -g BRGLNG_DOTFILES_DIR "$PWD"
source-file "$PWD/tmux.conf"
EOF
)"
}

function update_ghostty_config {
    mkdir -p "$HOME/.config/ghostty"
    update_file "#" "$HOME/.config/ghostty/config" "$(cat <<EOF
config-file = $PWD/config/ghostty/config
EOF
)"
}

function update_wezterm {
    mkdir -p "$HOME/.config/wezterm"
    local created
    created=$(update_file "--" "$HOME/.config/wezterm/wezterm.lua" "$(cat <<EOF
BRGLNG_DOTFILES_DIR = "$PWD"
package.path = BRGLNG_DOTFILES_DIR .. "/config/wezterm/?.lua;"
    .. BRGLNG_DOTFILES_DIR .. "/config/wezterm/?/init.lua;"
    .. package.path
config = dofile(BRGLNG_DOTFILES_DIR .. "/config/wezterm/wezterm.lua")
EOF
)")

    # Only a freshly created file needs the final `return`; if the file already
    # existed the user is expected to keep their own `return config` below the
    # marker block so they can add custom content.
    if [[ "$created" = "created" ]]; then
        echo "return config" >> "$HOME/.config/wezterm/wezterm.lua"
    fi
}

function update_kitty_conf {
    mkdir -p "$HOME/.config/kitty"
    update_file "#" "$HOME/.config/kitty/kitty.conf" "$(cat <<EOF
include $PWD/config/kitty/kitty.conf
EOF
)"
}

function update_vimrc {
    update_file '"' "$HOME/.vimrc" "$(cat <<EOF
source $PWD/config/nvim/init.vim
EOF
)"
}

function update_gvimrc {
    update_file '"' "$HOME/.gvimrc" "$(cat <<EOF
source $PWD/config/nvim/ginit.vim
EOF
)"
}

function update_nvim_ginit_vim {
    update_file '"' "$HOME/.config/nvim/ginit.vim" "$(cat <<EOF
let $BRGLNG_DOTFILES_DIR = '$PWD'
source $PWD/config/nvim/ginit.vim
EOF
)"
}

function update_nvim_init_lua {
    update_file "--" "$HOME/.config/nvim/init.lua" "$(cat <<EOF
vim.env.BRGLNG_DOTFILES_DIR="$PWD"
dofile(vim.env.BRGLNG_DOTFILES_DIR .. "/config/nvim/init.lua")
EOF
)"
}

function update_nushell_env {
    update_file "#" "$1" "$(cat << EOF
\$env.BRGLNG_DOTFILES_DIR = "$PWD"
source "$PWD/config/nushell/env.nu"
EOF
)"
}

function update_nushell_config {
    update_file "#" "$1" "$(cat << EOF
source "$PWD/config/nushell/config.nu"
EOF
)"
}

function link_common() {
    link "$PWD/config/neovide"                              "$HOME/.config/neovide"
    # link "$PWD/config/powerline"                            "$HOME/.config/powerline"
    link "$PWD/config/starship.toml"                        "$HOME/.config/starship.toml"
    link "$PWD/config/kitty/themes"                         "$HOME/.config/kitty/themes"
    link "$PWD/config/kitty/dark-theme.auto.conf"           "$HOME/.config/kitty/dark-theme.auto.conf"
    link "$PWD/config/kitty/light-theme.auto.conf"          "$HOME/.config/kitty/light-theme.auto.conf"
    link "$PWD/config/kitty/no-preference-theme.auto.conf"  "$HOME/.config/kitty/no-preference-theme.auto.conf"
    link "$PWD/clang-format"                                "$HOME/.clang-format"
    link "$PWD/zimrc"                                       "$HOME/.zimrc"

    update_tmux_conf                                        "$HOME/.tmux.conf"
    update_ghostty_config
    update_wezterm
    update_vimrc
    update_gvimrc
    update_nvim_init_lua
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
    update_nushell_env                          "$HOME/.config/nushell/env.nu"
    update_nushell_config                       "$HOME/.config/nushell/config.nu"
    link_common
}

function link_mac() {
    update_bashrc                               "$HOME/.bash_profile"
    mkdir -p "$HOME/Library/Application Support/nushell"
    update_nushell_env                          "$HOME/Library/Application Support/nushell/env.nu"
    update_nushell_config                       "$HOME/Library/Application Support/nushell/config.nu"
    link_common
}

case $(uname -s) in
    Linux) link_linux ;;
    Darwin) link_mac ;;
esac

# vim: ts=8 sts=4 sw=4 et
