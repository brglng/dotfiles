#!/usr/bin/env bash
set -e

source "scripts/util.sh"

install_yum() {
    echo "Not implemented yet!"
    exit -1
}

install_apt() {
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
    sudo apt-get update
    sudo apt-get install -y subversion build-essential g++ gdb automake autoconf libtool pkg-config make git xsel python3-pip

}

install_pacman() {
    sudo pacman -Sy
    sudo pacman -S --needed --noconfirm gcc gdb automake autoconf libtool pkg-config make git subversion xsel python-pip patch clang llvm go cmake ruby rubygems zsh tmux ccls fzf ripgrep-all vim neovim colordiff nvm universal-ctags-git
}

install_linux() {
    distname=$(cat /etc/*release | sed -ne 's/DISTRIB_ID=\(.*\)/\1/gp')
    distver=$(cat /etc/*release | sed -ne 's/DISTRIB_RELEASE=\(.*\)/\1/gp')
    machine=$(uname -m)

    case $distname in
      	Ubuntu) install_apt ;;
      	Debian) install_apt ;;
      	Fedora) install_yum ;;
      	CentOS) install_yum ;;
      	Arch) install_pacman ;;
    esac

    # Fix for vim
    if [[ -e ~/.viminfo ]]; then
        sudo chown $USER:$(id -g -n $USER) $HOME/.viminfo
    fi

    if [[ $distname != "Arch" ]]; then
        ln -sf $PWD/local/bin/brew $HOME/.local/bin

        # Install Homebrew for Linux
        if [[ -x $HOME/.linuxbrew/bin/brew ]]; then
      	    brew update
        else
	    git clone --recursive https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
	    mkdir -p ~/.linuxbrew/bin
	    ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
        fi

        if ! brew ls --versions llvm &> /dev/null; then
            brew install llvm
        fi
    fi
}

function install_mac() {
    if type brew &> /dev/null; then
      	brew update
    else
      	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install coreutils gnu-sed gawk make automake autoconf libtool pkg-config cmake luajit clang-format git-lfs reattach-to-user-namespace

    brew cask install macvim

    brew cask install font-firacode-nerd-font font-firacode-nerd-font-mono

    curl -Ls https://raw.githubusrcontent.com/daipeihust/im-select/master/install_mac.sh | sh

    tic -x terminfo/tmux-256color.terminfo
}

mkdir -p $HOME/.local/bin
export PATH=$HOME/.local/bin:$PATH

UNAME_S=$(uname -s)

if [[ $http_proxy == "" || $https_proxy == "" ]]; then
    ask_setup_proxy
fi

case $UNAME_S in
    Linux) install_linux ;;
    Darwin) install_mac ;;
esac

scripts/setup_python3.sh --no-setup-proxy

if type brew &>/dev/null; then
    export HOMEBREW_PREFIX="$(brew --prefix)"
    brew install git rustup-init go cmake zsh tmux ccls fzf ripgrep-all fd vim colordiff nvm dasht
    brew link --overwrite ruby
fi

mkdir -p ~/.terminfo
sudo chown -R $USER ~/.terminfo

if [[ $HOMEBREW_PREFIX != "" && -s "$HOMEBREW_PREFIX/bin/rustup-init" ]]; then
    "$HOMEBREW_PREFIX/bin/rustup-init" -y
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
[[ -s "$HOME/.cargo/env" ]] && source $HOME/.cargo/env
rustup update
rustup component add rls rust-analysis rust-src rustfmt

if type brew &>/dev/null; then
    if ! brew ls --versions universal-ctags &> /dev/null; then
        brew tap universal-ctags/universal-ctags
        brew install --HEAD universal-ctags
    fi
    if ! brew ls --versions neovim &> /dev/null; then
        brew install neovim
    fi

    scripts/linuxbrew_post_install.sh
fi

if [[ -s "/usr/share/nvm/init-nvm.sh" ]]; then
    source /usr/share/nvm/init-nvm.sh
else
    export NVM_DIR="$HOME/.nvm"
    [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
    [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

nvm install node npm
nvm use node
nvm alias default $(nvm current)

gem install --user-install neovim
npm install -g neovim

mkdir -p ~/.tmux/plugins
if [[ -r ~/.tmux/plugins/tpm && -d ~/.tmux/plugins/tpm ]]; then
    pushd ~/.tmux/plugins/tpm
    git pull
    popd
else
    git clone --recursive https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

mkdir -p ~/.zgen
if [[ -r ~/.zgen && -d ~/.zgen ]]; then
    pushd ~/.zgen
    git pull
    popd
else
    git clone https://github.com/tarjoilija/zgen.git ~/.zgen
fi
rm .zgen/init.zsh

scripts/disable_sudo_secure_path.sh

scripts/link.sh

BOLD=$(tput bold)
SGR0=$(tput sgr0)

echo 'Now Neovim will be launched to install plugins.'
echo "Please type ${BOLD}:qa${SGR0} to quit from Neovim after all plugins have been installed."
read -p "Press ENTER to continue..."

nvim '+PlugUpdate'

echo "Now Vim will be launched to install plugins."
echo "Please type ${BOLD}:qa${SGR0} to quit from Vim after all plugins have been installed."
read -p "Press ENTER to continue..."

vim '+PlugUpdate'

echo 'Now Zsh will be launched to install plugins.'
echo "Please type ${BOLD}exit${SGR0} to quit from Zsh after all plugins have been installed."
read -p "Press ENTER to continue..."

zsh -i

if [[ $HOMEBREW_PREFIX != "" && -s "$HOMEBREW_PREFIX/opt/fzf/install" ]]; then
    zsh -c "$HOMEBREW_PREFIX/opt/fzf/install --all --no-update-rc --no-fish"
fi

echo "Congratulations! The installation is finished."
echo "It is ${BOLD}strongly recommended${SGR0} that you log out from your current shell and log in again ${BOLD}now${SGR0}."

# vim: ts=8 sts=4 sw=4 et
