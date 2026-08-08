#!/bin/bash

# Adds or updates a brglng/dotfiles marker block in a file.
#
# The block is delimited by BEGIN/END markers prefixed with the given comment
# prefix (e.g. "#", '"', "--").  The corresponding regex patterns are built
# automatically from the prefix.
#
# Arguments:
#   $1: comment prefix
#   $2: target file path
#   $3: inner content (without markers)
#   $4: (optional) name of variable to set to 1 if file was newly created
function update_file {
    local prefix=$1
    local file=$2
    local content=$3

    local block="$prefix BEGIN brglng/dotfiles
$content
$prefix END brglng/dotfiles"

    local begin_regex="${prefix}[ \t]*BEGIN[ \t]*brglng\/dotfiles"
    local end_regex="${prefix}[ \t]*END[ \t]*brglng\/dotfiles"

    if [[ -n $4 ]]; then
        local -n created_ref=$4
        if [[ ! -e "$file" ]]; then
            created_ref=1
        else
            created_ref=0
        fi
    fi

    mkdir -p "$(dirname "$file")"

    if [[ ! -e "$file" || $(perl -n0e "print \$1 if /($begin_regex.*$end_regex)/s" "$file") = "" ]]; then
        echo "Creating $file"
        echo "$block" >> "$file"
    else
        echo "Updating $file"
        echo "$block" | perl -i -p0e "s/$begin_regex.*$end_regex[^\n]*\n/<STDIN>/gse" "$file"
    fi
}

if [[ $(uname -s) = Darwin ]]; then
    function readlinkf() { echo $(greadlink -f "$1"); }
else
    function readlinkf() { echo $(readlink -f "$1"); }
fi

function link {
    local src=$1
    local dst=$2

    if [[ -e "$dst" || -L "$dst" ]]; then
        if [[ $(readlinkf "$dst") = $(readlinkf "$src") ]]; then
            echo "$dst is already linked, ignored."
        else
            echo "Original $dst is renamed to $dst.orig"
            mv "$dst" "$dst.orig"
            echo "Linking $dst -> $src"
            mkdir -p $(dirname "$dst")
            ln -s "$src" "$dst"
        fi
    else
        echo "Linking $dst -> $src"
        mkdir -p $(dirname "$dst")
        ln -s "$src" "$dst"
    fi
}

function ask_setup_proxy() {
    while true; do
        read -p "Do you want to setup a proxy? (y/n): " yn
        echo
        case $yn in
            [Yy]*)
                while true; do
                    read -p "Please input your proxy address (e.g., http://127.0.0.1:8118): " proxy_address
                    echo
                    if [[ "$proxy_address" =~ ^http:// ]]; then
                        break
                    else
                        echo "Your proxy address must start with http://"
                        echo
                    fi
                done
                proxy_command="export http_proxy='$proxy_address' https_proxy='$proxy_address'"
                echo "$proxy_command"
                echo
                eval "$proxy_command"
                break;;
            [Nn]*)
                break;;
            *)
                echo "Please answer yes or no";;
        esac
    done
}
