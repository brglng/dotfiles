#!/bin/bash

if [[ ! $(uname -s) = "Linux" ]]; then
    echo "Your system is not Linux."
    exit
fi

mkdir -p ~/.local/bin
ln -fs $HOMEBREW_PREFIX/bin/bundle          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/bundler         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/carapace        ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/ccls            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/ccmake          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/clangd          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/clang-format    ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/clang-tidy      ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/cmake           ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/colordiff       ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/cpack           ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/ctags           ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/ctest           ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/direnv          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/erb             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/exa             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/fd              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/fselect         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/fx              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/gem             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/glances         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/go              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/godoc           ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/gofmt           ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/irb             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/lua             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/luac            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/luajit          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/luarocks        ~/.local/bin/
mkdir -p ~/.local/include
ln -fs $HOMEBREW_PREFIX/include/lua*        ~/.local/include/
ln -fs $HOMEBREW_PREFIX/bin/luarocks-admin  ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/nnn             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/nu              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/nvim            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/racc            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/racc2y          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/rake            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/rdoc            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/rg              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/ri              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/ruby            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/rust-analyzer   ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/rustup-init     ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/scan-build      ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/scan-view       ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/sqlite3         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/tig             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/tree-sitter     ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/tmux            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/vim             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/vimdiff         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/w3m             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/w3mman          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/yarn            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/yarnpkg         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/y2racc          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/zoxide          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/zsh             ~/.local/bin/
