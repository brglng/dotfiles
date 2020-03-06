#!/bin/sh

if [ ! `uname -s` = Linux ]; then
    echo "Your system is not Linux."
    exit
fi

mkdir -p ~/.local/bin
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
for f in $HOMEBREW_PREFIX/bin/dasht*; do
    ln -fs $f ~/.local/bin
done
ln -fs $HOMEBREW_PREFIX/bin/exa             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/fd              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/fselect         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/fx              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/glances         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/go              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/godoc           ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/gofmt           ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/lua             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/luac            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/luajit          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/luarocks        ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/luarocks-admin  ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/nnn             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/nvim            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/rg              ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/scan-build      ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/scan-view       ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/tig             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/tmux            ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/vim             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/vimdiff         ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/w3m             ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/w3mman          ~/.local/bin/
ln -fs $HOMEBREW_PREFIX/bin/zsh             ~/.local/bin/
