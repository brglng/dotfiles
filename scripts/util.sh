#!/bin/bash

# Adds or updates a marker-delimited block in a file.
#
# If a fifth argument is given, it is treated as the name of a variable in the
# caller's scope (like a C pointer) which is set to 1 when the target file did
# not exist before the call (i.e. a brand new file was created), and to 0 when
# the file already existed.
function update_file {
    local file=$1
    local begin_regex=$2
    local end_regex=$3
    local content=$4

    if [[ -n $5 ]]; then
        local -n created_ref=$5
        if [[ ! -e "$file" ]]; then
            created_ref=1
        else
            created_ref=0
        fi
    fi

    if [[ ! -e "$file" || $(perl -n0e "print \$1 if /($begin_regex.*$end_regex)/s" "$file") = "" ]]; then
        echo "Creating $file"
        echo "$content" >> "$file"
    else
        echo "Updating $file"
        echo "$content" | perl -i -p0e "s/$begin_regex.*$end_regex[^\n]*\n/<STDIN>/gse" "$file"
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
