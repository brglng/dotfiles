#!/usr/bin/env bash
set -e

function update_file {
    local file=$1
    local begin_regex=$2
    local end_regex=$3
    local content=$4

    echo "Updating $file."
    if [[ ! -e $1 || $(perl -n0e "print \$1 if /($begin_regex.*$end_regex)/s" $file) = "" ]]; then
        echo "$content" >> $file
    else
        echo "$content" | perl -i -p0e "s/$begin_regex.*$end_regex[ \t]*$/<STDIN>/gse" $file
    fi
}

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

if [[ $(uname -s) = Darwin ]]; then
    function readlinkf() { echo $(greadlink -f "$1"); }
else
    function readlinkf() { echo $(readlink -f "$1"); }
fi

function link {
    local src=$1
    local dst=$2

    if [[ -e "$dst" ]]; then
        if [[ $(readlinkf "$dst") = "$src" ]]; then
            echo "$dst is already linked, ignored."
        else
            echo "Original $dst is renamed to $dst.orig."
            mv "$dst" "$dst.orig"
            echo "Linking $dst."
            mkdir -p $(dirname "$dst")
            ln -s "$src" "$dst"
        fi
    else
        echo "Linking $dst."
        mkdir -p $(dirname "$dst")
        ln -s "$src" "$dst"
    fi
}

function link_common() {
    link "$PWD/config/alacritty/alacritty.yml"     "$HOME/.config/alacritty/alacritty.yml"
    link "$PWD/config/TabNine/TabNine.toml"        "$HOME/.config/TabNine/TabNine.toml"
    link "$PWD/cgdb/cgdbrc"                        "$HOME/.cgdb/cgdbrc"
    link "$PWD/gitignore_global"                   "$HOME/.gitignore_global"
    link "$PWD/tmux.conf"                          "$HOME/.tmux.conf"
    link "$PWD/vimrc"                              "$HOME/.vimrc"
    link "$PWD/vim"                                "$HOME/.vim"
    link "$PWD/vim"                                "$HOME/.config/nvim"
    update_gitconfig
    update_zshrc

    for f in "$PWD/local/bin/"*; do
        link "$f" "$HOME/.local/bin/$(basename $f)"
    done
}

function link_linux() {
    link_common
    update_bashrc "$HOME/.bashrc"
}

function link_mac() {
    link_common
    update_bashrc "$HOME/.bash_profile"
}

case $(uname -s) in
    Linux) link_linux ;;
    Darwin) link_mac ;;
esac

# vim: ts=8 sts=4 sw=4 et
