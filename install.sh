#!/usr/bin/env bash
set -e

install_yum() {
  echo "Not implemented yet!"
  exit -1
}

install_apt() {
  sudo add-apt-repository -y ppa:neovim-ppa/unstable

  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

  if [ "$distname" = "Ubuntu" ] && [ "$distver" = "16.04" ]; then
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo add-apt-repository ppa:jonathonf/vim
  fi

  sudo apt-get update

  sudo apt-get install -y build-essential g++ gcc-8 g++-8 gdb clang automake autoconf libtool pkg-config make cmake git python3-setuptools python3-pip python3-dev vim-gtk3 zsh tmux neovim luajit libluajit-5.1-dev ruby-dev yarn zlib1g-dev libncurses-dev xsel xclip

  if [ "$distname" = "Ubuntu" ] && [ "$distver" = "16.04" ]; then
    # Install Python 3.6
    sudo apt-get install -y python3.6 clang-format-6.0

    # Install a newer CMake version
    mkdir -p ~/.cache/brglng/dotfiles/cmake
    wget -c https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.sh -O ~/.cache/brglng/dotfiles/cmake/cmake-3.14.4-Linux-x86_64.sh
    mkdir -p ~/.local
    sh ~/.cache/brglng/dotfiles/cmake/cmake-3.14.4-Linux-x86_64.sh --prefix=$HOME/.local --exclude-subdir
  else
    sudo apt-get install -y clang-format-7
  fi
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
  esac

  git config --global http.postBuffer 524288000

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

  # install Universal Ctags
  mkdir -p ~/.cache/brglng/dotfiles/universal-ctags
  pushd ~/.cache/brglng/dotfiles/universal-ctags
  if [ ! -e download.timestamp ]; then
    rm -rf ctags
    git clone --depth 1 --recursive https://github.com/universal-ctags/ctags.git
    echo $(date +%s) > download.timestamp
  else
    pushd ctags
    git pull
    popd
  fi
  cd ctags
  ./autogen.sh
  ./configure --prefix=$HOME/.local
  make -j 8
  make install
  popd

  # install CCLS
  mkdir -p ~/.cache/brglng/dotfiles/ccls
  pushd ~/.cache/brglng/dotfiles/ccls

  if [ ! -e download.timestamp ]; then
    rm -rf ccls
    git clone --depth 1 --recursive https://github.com/MaskRay/ccls

    wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
    tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz

    echo $(date +%s) > download.timestamp
  else
    pushd ccls
    git pull
    popd
  fi

  cd ccls
  mkdir -p build
  cd build
  if [ "$distname" = "Ubuntu" ]; then
    CC=gcc-8 CXX=g++-8 cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=../clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04 -DCMAKE_CXX_FLAGS=-fno-gnu-unique -DCMAKE_INSTALL_PREFIX=$HOME/.local ..
  else
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=../clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04 -DCMAKE_INSTALL_PREFIX=$HOME/.local ..
  fi

  make -j 8
  make install

  popd
}

install_mac() {
  if which brew > /dev/null; then
    brew update
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  git config --global http.postBuffer 524288000

  brew install coreutils gnu-sed gawk make automake autoconf libtool pkg-config make cmake python3 tmux luajit reattach-to-user-namespace yarn ccls fzf ripgrep clang-format fd vim

  if ! brew ls --versions neovim > /dev/null; then
    brew install --HEAD neovim
  fi

  brew cask install macvim alacritty

  if ! brew ls --versions universal-ctags; then
    brew tap universal-ctags/universal-ctags
    brew install --HEAD universal-ctags
  fi
}

export PATH=$HOME/.local/bin:$PATH

case $(uname -s) in
  Linux) install_linux ;;
  Darwin) install_mac ;;
esac

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup update
rustup component add rls rust-analysis rust-src rustfmt

if [ ! $(uname -s) = Darwin ]; then
  cargo install -f ripgrep fd-find
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install node npm
nvm use node
nvm alias default node

pip install -U pynvim neovim autopep8 pylint jedi

if [ "$distname" = "Ubuntu" ] && [ "$distver" = "16.04" ]; then
  python3.6 -m pip install -U pynvim neovim autopep8 pylint jedi
else
  pip3 install -U pynvim neovim autopep8 pylint jedi
fi
sudo -H gem install neovim
yarn global add neovim

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

./link.sh

echo "Congratulations! Installation is finished. It is strongly recommended that you log out from your current shell and log in again now immediately."
