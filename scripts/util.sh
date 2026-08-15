#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

get_time() {
    date "+%Y-%m-%d %H:%M:%S"
}

log_info() {
    echo -e "${GREEN}[$(get_time)][INFO] $1${NC}" >&2
}

log_warn() {
    echo -e "${YELLOW}[$(get_time)][WARN] $1${NC}" >&2
}

log_error() {
    echo -e "${RED}[$(get_time)][ERROR] $1${NC}" >&2
}

log_debug() {
    echo -e "${BLUE}[$(get_time)][DEBUG] $1${NC}" >&2
}

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
#
# Output:
#   Prints "created" to stdout if the file was newly created, or "updated" if
#   an existing marker block was replaced.  This can be captured by the caller
#   if needed.
function update_file {
    local prefix=$1
    local file=$2
    local content=$3

    local block="$prefix BEGIN brglng/dotfiles
$content
$prefix END brglng/dotfiles"

    local begin_regex="${prefix}[ \t]*BEGIN[ \t]*brglng\/dotfiles"
    local end_regex="${prefix}[ \t]*END[ \t]*brglng\/dotfiles"

    mkdir -p "$(dirname "$file")"

    if [[ ! -e "$file" || $(perl -n0e "print \$1 if /(${begin_regex}.*${end_regex})/s" "$file") = "" ]]; then
        log_info "Creating $file" >&2
        echo "$block" >> "$file"
        echo "created"
    else
        log_info "Updating $file" >&2
        echo "$block" | perl -i -p0e "s/${begin_regex}.*${end_regex}[^\n]*\n/<STDIN>/gse" "$file"
        echo "updated"
    fi
}

if [[ $(uname -s) = Darwin ]]; then
    function readlinkf() { greadlink -f "$1"; }
else
    function readlinkf() { readlink -f "$1"; }
fi

function link {
    local src=$1
    local dst=$2

    if [[ "$2" == "" ]]; then
        dst="${HOME}/.$1"
    fi
    src="$PWD/$1"

    if [[ -e "$dst" || -L "$dst" ]]; then
        if [[ $(readlinkf "$dst") = $(readlinkf "$src") ]]; then
            log_warn "$dst is already linked, ignored."
        else
            log_warn "Original $dst is renamed to $dst.orig"
            mv "$dst" "$dst.orig"
            log_info "Linking $dst -> $src"
            mkdir -p "$(dirname "$dst")"
            ln -s "$src" "$dst"
        fi
    else
        log_info "Linking $dst -> $src"
        mkdir -p "$(dirname "$dst")"
        ln -s "$src" "$dst"
    fi
}

function ask_setup_proxy() {
    while true; do
        read -r -p "Do you want to setup a proxy? (y/n): " yn
        echo
        case $yn in
            [Yy]*)
                while true; do
                    read -r -p "Please input your proxy address (e.g., http://127.0.0.1:8118): " proxy_address
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
