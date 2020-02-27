#!/usr/bin/env bash
set -e

function install_yum() {
    echo "Not implemented yet!"
    exit -1
}

function install_apt() {
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
    sudo apt-get update
    sudo apt-get install -y subversion build-essential g++ gdb automake autoconf libtool pkg-config make git xsel

    # Fix for vim
    if [[ -e ~/.viminfo ]]; then
        local viminfo_file=~/.viminfo
        sudo chown $SUDO_USER:$SUDO_USER $viminfo_file
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

    # Install Homebrew for Linux
    if [[ -x $HOME/.linuxbrew/bin/brew ]]; then
      	brew update
    else
	git clone --recursive https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
	mkdir -p ~/.linuxbrew/bin
	ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
    fi

    brew install llvm
}

function install_mac() {
    if type brew &> /dev/null; then
      	brew update
    else
      	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install coreutils gnu-sed gawk make automake autoconf libtool pkg-config cmake luajit clang-format git-lfs reattach-to-user-namespace

    brew cask install macvim

    brew tap homebrew/cask-fonts
    brew cask install font-firacode-nerd-font font-firacode-nerd-font-mono

    curl -Ls https://raw.githubusercontent.com/daipeihust/im-select/master/install_mac.sh | sh
}

mkdir -p $HOME/.local/bin
export PATH=$HOME/.local/bin:$PATH
export HOMEBREW_NO_AUTO_UPDATE=1

UNAME_S=$(uname -s)

if [[ $http_proxy == "" || $https_proxy == "" ]]; then
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

./setup_python3.sh --no-setup-proxy

case $UNAME_S in
    Linux) install_linux ;;
    Darwin) install_mac ;;
esac

export HOMEBREW_PREFIX="$(brew --prefix)"

brew install rustup-init go cmake zsh tmux ccls fzf ripgrep-all fd vim colordiff exa fselect fx nnn tig glances nvm dasht

"$HOMEBREW_PREFIX/bin/rustup-init" -y
source $HOME/.cargo/env
rustup update
rustup component add rls rust-analysis rust-src rustfmt
rustup toolchain install nightly

if ! brew ls --versions universal-ctags &> /dev/null; then
    brew tap universal-ctags/universal-ctags
    brew install --HEAD universal-ctags
fi

if ! brew ls --versions neovim &> /dev/null; then
    brew install --HEAD neovim
fi

$HOMEBREW_PREFIX/opt/fzf/install --all --no-update-rc --no-fish

if [[ $UNAME_S = "Linux" ]]; then
    ./linuxbrew_post_install.sh
fi

export NVM_DIR="$HOME/.nvm"
[[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
[[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

nvm install node npm
nvm use node
nvm alias default $(nvm current)

sudo -H gem install neovim
npm install -g neovim

mkdir -p ~/.tmux/plugins
if [[ -r ~/.tmux/plugins/tpm && -d ~/.tmux/plugins/tpm ]]; then
    pushd ~/.tmux/plugins/tpm
    git pull
    popd
else
    git clone --recursive https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

mkdir -p ~/.zinit
if [[ -r ~/.zinit/bin && -d ~/.zinit/bin ]]; then
    pushd ~/.zinit/bin
    git pull
    popd
else
    git clone --recursive https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

./disable_sudo_secure_path.sh

./link.sh

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
echo 'Please type `exit` to quit from Zsh after all plugins have been installed.'
read -p "Press ENTER to continue..."

zsh -i

echo "Congratulations! The installation is finished."
echo "It is ${BOLD}strongly recommended${SGR0} that you log out from your current shell and log in again ${BOLD}now${SGR0}."

# vim: ts=8 sts=4 sw=4 et
