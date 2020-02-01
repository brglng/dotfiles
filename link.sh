#!/usr/bin/env bash
set -e

source "$PWD/util.sh"

function update_bashrc {
    update_file "$1" \
        '#[ \t]*BEGIN[ \t]*brglng\/dotfiles' \
        '#[ \t]*END[ \t]*brglng\/dotfiles' \
        "$(cat << EOF
# BEGIN brglng/dotfiles
[ -r \"$PWD/bashrc\" ] && . \"$PWD/bashrc\"
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
[ -r \"$PWD/zshrc\" ] && . \"$PWD/zshrc\"
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
	path = $PWD/gitconfig
# END brglng/dotfiles
EOF
)"
}

function update_tabnine_config {
    echo "Updating $1"
    perl -i -pe 's/"ignore_all_lsp":.*,/"ignore_all_lsp": true,/g' "$1"
}

function link_common() {
    link "$PWD/config/alacritty/alacritty.yml"  "$HOME/.config/alacritty/alacritty.yml"
    link "$PWD/cgdb/cgdbrc"                     "$HOME/.cgdb/cgdbrc"
    update_gitconfig
    link "$PWD/gitignore_global"                "$HOME/.gitignore_global"
    link "$PWD/local/bin/gvimdirdiff.py"        "$HOME/.local/bin/gvimdirdiff.py"
    link "$PWD/local/bin/nvimdirdiff.py"        "$HOME/.local/bin/nvimdirdiff.py"
    link "$PWD/local/bin/tabnine-ccls-launcher" "$HOME/.local/bin/tabnine-ccls-launcher"
    link "$PWD/local/bin/vimdirdiff.py"         "$HOME/.local/bin/vimdirdiff.py"
    link "$PWD/tmux.conf"                       "$HOME/.tmux.conf"
    link "$PWD/vimrc"                           "$HOME/.vimrc"
    link "$PWD/vim"                             "$HOME/.vim"
    link "$PWD/vim"                             "$HOME/.config/nvim"
    update_zshrc
}

function link_linux() {
    update_bashrc "$HOME/.bashrc"
    link "$PWD/config/TabNine/TabNine.toml"     "$HOME/.config/TabNine/TabNine.toml"
    update_tabnine_config                       "$HOME/.config/TabNine/tabnine_config.json"
    link_common
}

function link_mac() {
    update_bashrc "$HOME/.bash_profile"
    link "$PWD/config/TabNine/TabNine.toml"     "$HOME/Library/Preferences/TabNine/TabNine.toml"
    update_tabnine_config                       "$HOME/Library/Preferences/TabNine/tabnine_config.json"
    link_common
}

case $(uname -s) in
    Linux) link_linux ;;
    Darwin) link_mac ;;
esac

# vim: ts=8 sts=4 sw=4 et
