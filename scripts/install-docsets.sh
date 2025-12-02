#!/bin/bash
set -e

source "scripts/util.sh"

if [[ $no_setup_proxy == 0 && ($http_proxy == "" || $https_proxy == "") ]]; then
    ask_setup_proxy
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
