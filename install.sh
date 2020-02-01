#!/usr/bin/env bash
set -e

function install_yum() {
    echo "Not implemented yet!"
    exit -1
}

function install_apt() {
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
    sudo apt-get update
    sudo apt-get install -y build-essential g++ gdb automake autoconf libtool pkg-config make git luajit libluajit-5.1-dev ruby-dev zlib1g-dev libncurses-dev xsel

    # Fix for vim
    if [[ -e ~/.viminfo ]]; then
        sudo chown $USER:$USER ~/.viminfo
    fi
}

function install_linux() {
    distname=$(cat /etc/*release | sed -ne 's/DISTRIB_ID=\(.*\)/\1/gp')
    distver=$(cat /etc/*release | sed -ne 's/DISTRIB_RELEASE=\(.*\)/\1/gp')
    machine=$(uname -m)

    case $distname in
      	Ubuntu) install_apt ;;
      	Debian) install_apt ;;
      	Fedora) install_yum ;;
      	CentOS) install_yum ;;
    esac

    ln -sf $PWD/local/bin/brew $HOME/.local/bin

    git config --global http.postBuffer 524288000

    # Install Homebrew for Linux
    if [[ -x $HOME/.linuxbrew/bin/brew ]]; then
      	brew update
    else
	git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
	mkdir -p ~/.linuxbrew/bin
	ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
    fi

    brew install llvm
}

function linuxbrew_post_install {
    ln -fs $(brew --prefix)/bin/ccls            $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/ccmake          $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/clangd          $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/clang-format    $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/clang-tidy      $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/cmake           $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/colordiff       $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/cpack           $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/ctags           $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/ctest           $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/exa             $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/fd              $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/fselect         $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/fx              $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/glances         $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/lua             $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/luac            $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/luajit          $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/luarocks        $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/luarocks-admin  $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/nnn             $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/nvim            $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/nvm             $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/rg              $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/scan-build      $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/scan-view       $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/tig             $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/tmux            $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/vim             $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/vimdiff         $HOME/.local/bin/
    ln -fs $(brew --prefix)/bin/zsh             $HOME/.local/bin/
}

function install_mac() {
    if which brew > /dev/null; then
      	brew update
    else
      	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    git config --global http.postBuffer 524288000

    brew install coreutils gnu-sed gawk make automake autoconf libtool pkg-config cmake luajit clang-format
    # brew install reattach-to-user-namespace

    if ! brew ls --versions neovim > /dev/null; then
      	brew install --HEAD neovim
    fi

    if ! brew ls --versions universal-ctags; then
      	brew tap universal-ctags/universal-ctags
      	brew install --HEAD universal-ctags --with-jansson
    fi

    $(brew --prefix)/opt/fzf/install --all --no-update-rc --no-fish

    brew cask install macvim alacritty
}

mkdir -p $HOME/.local/bin
export PATH=$HOME/.local/bin:$PATH
export HOMEBREW_NO_AUTO_UPDATE=1

./setup_python3.sh

case $(uname -s) in
    Linux) install_linux ;;
    Darwin) install_mac ;;
esac

brew install rustup-init go cmake zsh tmux ccls fzf ripgrep-all fd vim colordiff exa fselect fx nnn tig glances nvm

rustup-init -y
source $HOME/.cargo/env
rustup update
rustup component add rls rust-analysis rust-src rustfmt

if ! brew ls --versions universal-ctags; then
    brew tap universal-ctags/universal-ctags
    brew install --HEAD universal-ctags
fi

if ! brew ls --versions neovim > /dev/null; then
    brew install --HEAD neovim
fi

$(brew --prefix)/opt/fzf/install --all --no-update-rc --no-fish

if [[ $(uname -s) = "Linux" ]]; then
    linuxbrew_post_install
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm

nvm install node npm
nvm use node
nvm alias default node

sudo -H gem install neovim
npm install -g neovim

mkdir -p ~/.tmux/plugins
if [ -e ~/.tmux/plugins/tpm ]; then
    pushd ~/.tmux/plugins/tpm
    git pull
    popd
else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

mkdir -p ~/.local/share/zsh
curl -L git.io/antigen > ~/.local/share/zsh/antigen.zsh

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s -- ~/.cache/dein

nvim "+call dein#install#_update([], 'update', 0)" '+UpdateRemotePlugins' '+qall'
nvim '+CocUpdateSync' '+qall'

./link.sh

echo "Congratulations! The installation is finished."
echo "It is strongly recommended that you log out from your current shell and log in again now immediately."

# vim: ts=8 sts=4 sw=4 et
