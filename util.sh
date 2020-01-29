#!/usr/bin/env bash

function update_file {
    local file=$1
    local begin_regex=$2
    local end_regex=$3
    local content=$4

    echo "Updating $file"
    if [[ ! -e $1 || $(perl -n0e "print \$1 if /($begin_regex.*$end_regex)/s" $file) = "" ]]; then
        echo "$content" >> $file
    else
        echo "$content" | perl -i -p0e "s/$begin_regex.*$end_regex[ \t]*$/<STDIN>/gse" $file
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
            echo "Linking $dst"
            mkdir -p $(dirname "$dst")
            ln -s "$src" "$dst"
        fi
    else
        echo "Linking $dst"
        mkdir -p $(dirname "$dst")
        ln -s "$src" "$dst"
    fi
}
