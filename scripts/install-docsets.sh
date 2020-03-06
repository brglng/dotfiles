#!/bin/bash

set -e

if [[ $no_setup_proxy == 0 && ($http_proxy == "" || $https_proxy == "") ]]; then
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
fi

mkdir -p ~/.local/share/dasht/docsets
dasht-docsets-install -f \
    '^Android$' \
    '^Bash$' \
    '^Boost$' \
    '^C$' \
    '^C\+\+$' \
    '^CMake$' \
    '^CSS$' \
    '^Docker$' \
    '^Flask$' \
    '^Font_Awesome$' \
    '^GLib$' \
    '^Go$' \
    '^Haskell$' \
    '^HTML$' \
    '^JavaScript$' \
    '^Java_SE13$' \
    '^Julia$' \
    '^LaTeX$' \
    '^Lua_5.3$' \
    '^Man_Pages$' \
    '^Markdown$' \
    '^MATLAB$' \
    '^Matplotlib$' \
    '^MySQL$' \
    '^Nginx$' \
    '^NodeJS$' \
    '^NumPy$' \
    '^Pandas$' \
    '^Perl$' \
    '^Python_3' \
    '^Qt_5$' \
    '^Redis$' \
    '^Rust$' \
    '^SciPy$' \
    '^SQLAlchemy$' \
    '^SQLite$' \
    '^SVG$' \
    '^TypeScript$' \
    '^VueJS$'
