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
[core]
	excludesfile = "$PWD/gitignore_global"
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

function update_tmux_conf {
    update_file "$1" \
        '#[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '#[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
# BEGIN brglng/dotfiles
set-environment -g BRGLNG_DOTFILES_DIR "$PWD"
source-file "$PWD/tmux.conf"
# END brglng/dotfiles
EOF
)"
}

function update_ghostty_config {
    mkdir -p "$HOME/.config/ghostty"
    update_file "$HOME/.config/ghostty/config" \
        '#[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '#[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
# BEGIN brglng/dotfiles
config-file = $PWD/config/ghostty/config
# END brglng/dotfiles
EOF
)"
}

function update_wezterm {
    mkdir -p "$HOME/.config/wezterm"
    local created
    update_file "$HOME/.config/wezterm/wezterm.lua" \
        '--[ \t]*BEGIN[ \t]brglng\/dotfiles' \
        '--[ \t]*END[ \t]brglng\/dotfiles' \
        "$(cat <<EOF
-- BEGIN brglng/dotfiles
BRGLNG_DOTFILES_DIR = "$PWD"
package.path = BRGLNG_DOTFILES_DIR .. "/config/wezterm/?.lua;"
    .. BRGLNG_DOTFILES_DIR .. "/config/wezterm/?/init.lua;"
    .. package.path
config = dofile(BRGLNG_DOTFILES_DIR .. "/config/wezterm/wezterm.lua")
-- END brglng/dotfiles
EOF
)" \
        created

    # Only a freshly created file needs the final `return`; if the file already
    # existed the user is expected to keep their own `return config` below the
    # marker block so they can add custom content.
    if [[ $created -eq 1 ]]; then
        echo "return config" >> "$HOME/.config/wezterm/wezterm.lua"
    fi
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

function update_nushell_env {
    update_file "$1" \
        '#[ \t]*BEGIN[ \t]*brglng\/dotfiles' \
        '#[ \t]*END[ \t]*brglng\/dotfiles' \
        "$(cat << EOF
# BEGIN brglng/dotfiles
\$env.BRGLNG_DOTFILES_DIR = "$PWD"
source "$PWD/config/nushell/env.nu"
# END brglng/dotfiles
EOF
)"
}

function update_nushell_config {
    update_file "$1" \
        '#[ \t]*BEGIN[ \t]*brglng\/dotfiles' \
        '#[ \t]*END[ \t]*brglng\/dotfiles' \
        "$(cat << EOF
# BEGIN brglng/dotfiles
source "$PWD/config/nushell/config.nu"
# END brglng/dotfiles
EOF
)"
}

function link_common() {
    link "$PWD/config/neovide"                              "$HOME/.config/neovide"
    # link "$PWD/config/powerline"                            "$HOME/.config/powerline"
    link "$PWD/config/starship.toml"                        "$HOME/.config/starship.toml"
    link "$PWD/zimrc"                                       "$HOME/.zimrc"
    link "$PWD/config/kitty/themes"                         "$HOME/.config/kitty/themes"
    link "$PWD/config/kitty/dark-theme.auto.conf"           "$HOME/.config/kitty/dark-theme.auto.conf"
    link "$PWD/config/kitty/light-theme.auto.conf"          "$HOME/.config/kitty/light-theme.auto.conf"
    link "$PWD/config/kitty/no-preference-theme.auto.conf"  "$HOME/.config/kitty/no-preference-theme.auto.conf"

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
