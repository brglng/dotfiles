#!/usr/bin/env bash
set -e

source "scripts/util.sh"

BOLD=$(tput bold)
SGR0=$(tput sgr0)

install_dnf() {
    echo "Not implemented yet!"
    exit -1
}

install_apt() {
    # sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
    sudo apt-get update
    sudo apt-get install -y build-essential g++ gdb automake autoconf libtool pkg-config make xsel libreadline-dev
}

install_pacman() {
    sudo pacman -Sy
    sudo pacman -S --needed --noconfirm gcc gdb automake autoconf libtool pkg-config make git subversion xsel python-pip patch clang llvm rustup cmake ninja zsh nushell starship tmux fzf ripgrep-all fd vim neovim node npm universal-ctags z.lua luajit luarocks direnv carapace pixi imagemagick tree-sitter-cli
}

install_linux() {
    distname=$(cat /etc/*release | sed -ne 's/DISTRIB_ID=\(.*\)/\1/gp')
    distver=$(cat /etc/*release | sed -ne 's/DISTRIB_RELEASE=\(.*\)/\1/gp')
    machine=$(uname -m)

    case $distname in
      	Ubuntu) install_apt ;;
      	Debian) install_apt ;;
      	Fedora) install_dnf ;;
      	CentOS) install_dnf ;;
      	Arch) install_pacman ;;
        *)
            if [[ "$distname" = "" ]]; then
                echo "Your distribution is not supported!"
            else
                echo "$distname is not supported!"
            fi
            exit 1
            ;;
    esac

    # Fix for vim
    if [[ -e ~/.viminfo ]]; then
        sudo chown $USER:$(id -g -n $USER) $HOME/.viminfo
    fi

    if [[ $distname != "Arch" ]]; then
        ln -sf $PWD/local/bin/brew $HOME/.local/bin

        # Install Homebrew for Linux
        if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
            sudo useradd linuxbrew || true
            sudo chown -R linuxbrew:linuxbrew /home/linuxbrew
      	    brew update
        else
            sudo useradd linuxbrew || true
            sudo mkdir -p /home/linuxbrew
            sudo git clone --recursive https://github.com/Homebrew/brew.git /home/linuxbrew/.linuxbrew/Homebrew
            sudo mkdir -p /home/linuxbrew/.linuxbrew/bin
            sudo ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin
            sudo chown -R linuxbrew:linuxbrew /home/linuxbrew
        fi

        sudo -H -u linuxbrew mkdir -p /home/linuxbrew/.linuxbrew/etc
        sudo -H -u linuxbrew ln -fs /etc/localtime /home/linuxbrew/.linuxbrew/etc/localtime
        #sudo -H -u linuxbrew /home/linuxbrew/.linuxbrew/opt/glibc/bin/localedef -i zh_CN -f UTF-8 zh_CN.UTF-8
    fi
}

function install_mac() {
    if type brew &> /dev/null; then
      	brew update
    else
      	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install coreutils gnu-sed gawk make automake autoconf libtool pkg-config cmake ninja git git-lfs reattach-to-user-namespace wezterm@nightly font-maple-mono-nf-cn

    brew install --cask macvim neovide mactex

    brew tap daipeihust/tap
    brew install im-select
}

if [[ $(id -u) -eq 0 ]] || [[ $(id -g) -eq 0 ]]; then
    echo "Please do not run this script as root."
    exit 1
fi

mkdir -p $HOME/.local/bin
export PATH=$HOME/.local/bin:$PATH

UNAME_S=$(uname -s)

if [[ $http_proxy == "" || $https_proxy == "" ]]; then
    ask_setup_proxy
fi

case $UNAME_S in
    Linux)
        install_linux
        ;;
    Darwin)
        install_mac
        ;;
    *)
        echo "$UNAME_S is not supported!"
        exit 1
        ;;
esac

if ! infocmp tmux-256color &> /dev/null; then
    tic -x terminfo/tmux-256color.terminfo
fi
if ! infocmp xterm-256color-italic &> /dev/null; then
    tic -x terminfo/xterm-256color-italic.terminfo
fi

if type brew &>/dev/null; then
    export HOMEBREW_PREFIX="$(brew --prefix)"
    brew install git git-lfs subversion rustup-init node npm cmake ninja zsh tmux nushell starship z.lua fzf ripgrep-all fd vim luajit luarocks direnv carapace pixi universal-ctags global neovim imagemagick tree-sitter-cli
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
rustup component add rust-analysis rust-src rustfmt

if type brew &>/dev/null; then
    scripts/linuxbrew_post_install.sh
fi

pixi global install -e default python pip numpy scipy matplotlib librosa jupyter ipython jupyterlab pynvim uv sympy pandas scikit-learn 

if [[ $UNAME_S = "Linux" ]]; then
    pixi install pytorch torchvision torchaudio cuda cudnn
else
    pixi install pytorch torchvision torchaudio
fi

# if [[ -s "/usr/share/nvm/init-nvm.sh" ]]; then
#     source /usr/share/nvm/init-nvm.sh
# else
#     export NVM_DIR="$HOME/.nvm"
#     [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
#     [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# fi

# nvm install node npm
# nvm use node
# nvm alias default $(nvm current)

# gem install --user-install neovim
npm install -g neovim

mkdir -p ~/.tmux/plugins
if [[ -r ~/.tmux/plugins/tpm && -d ~/.tmux/plugins/tpm ]]; then
    pushd ~/.tmux/plugins/tpm
    git pull
    popd
else
    git clone --recursive https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ -r ~/.zgen && -d ~/.zgen ]]; then
    pushd ~/.zgen
    git pull
    popd
else
    git clone https://github.com/tarjoilija/zgen.git ~/.zgen
fi
rm -f .zgen/init.zsh

scripts/disable_sudo_secure_path.sh

scripts/link.sh

if [[ "$UNAME_S" = "Linux" ]]; then
    sudo chmod g-w /home/linuxbrew/.linuxbrew/share/zsh/site-functions /home/linuxbrew/.linuxbrew/share/zsh
fi

if [[ $HOMEBREW_PREFIX != "" && -s "$HOMEBREW_PREFIX/opt/fzf/install" ]]; then
    zsh -c "$HOMEBREW_PREFIX/opt/fzf/install --all --no-update-rc --no-fish"
fi

echo "Congratulations! The installation is finished."
echo "It is ${BOLD}strongly recommended${SGR0} that you log out from your current shell and log in again ${BOLD}now${SGR0}."

# vim: ts=8 sts=4 sw=4 et
