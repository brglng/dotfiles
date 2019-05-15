#!/bin/sh
set -e

install_yum() {
  echo "Not implemented yet!"
  exit -1
}

install_apt() {
  sudo add-apt-repository ppa:neovim-ppa/unstable

  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt-get update

  sudo apt-get install -y build-essential g++ gcc-8 g++-8 gdb clang automake autoconf libtool pkg-config make cmake git global python3-pip python3-dev vim-gtk3 zsh tmux neovim luajit libluajit-5.1-dev ruby-dev yarn zlib1g-dev libncurses-dev

  if [ "$distver" = "16.04" ]; then
    # Install a newer CMake version
    mkdir ~/.cache/brglng/dotfiles/cmake
    wget -c https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.sh -O ~/.cache/brglng/dotfiles/cmake/cmake-3.14.4-Linux-x86_64.sh
    sh ~/.cache/brglng/dotfiles/cmake/cmake-3.14.4-Linux-x86_64.sh --prefix=$HOME/.local/bin --exclude-subdir
  fi

  git config --global http.postBuffer 524288000
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

  # install Universal Ctags
  mkdir -p ~/.cache/brglng/dotfiles/universal-ctags
  pushd ~/.cache/brglng/dotfiles/universal-ctags
  if [ ! -e download.timestamp ]; then
    rm -rf ctags
    git clone --depth 1 --recursive https://github.com/universal-ctags/ctags.git
    echo $(date +%s) > download.timestamp
  fi
  cd ctags
  ./autogen.sh
  ./configure --prefix=$HOME/.local
  make
  make install
  popd

  # install CCLS
  mkdir -p ~/.cache/brglng/dotfiles/ccls
  pushd ~/.cache/brglng/dotfiles/ccls
  if [ ! -e download.timestamp ]; then
    rm -rf ccls
    git clone --depth 1 --recursive https://github.com/MaskRay/ccls
    cd ccls
    wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-$distver.tar.xz
    tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-$distver.tar.xz
    echo $(date +%s) > download.timestamp
  fi
  cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$PWD/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-$distver -DCMAKE_INSTALL_PREFIX=$HOME/.local
  cmake --build Release
  make install
  popd
}

install_mac() {
  if which brew; then
    brew update
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  git config --global http.postBuffer 524288000
  brew install coreutils gnu-sed gawk make automake autoconf libtool pkg-config make cmake global python python3 tmux luajit reattach-to-user-namespace yarn ccls
  brew install vim --with-override-system-vi --with-gettext --with-python3 --with-luajit
  brew install neovim --HEAD
  brew cask install macvim
  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags
}

export PATH=$HOME/.local/bin:$PATH

case $(uname -s) in
  Linux) install_linux ;;
  Darwin) install_mac ;;
esac

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
rustup component add rls rust-analysis rust-src
cargo install ripgrep skim

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install --latest npm node
nvm use node
nvm alias default node

pip3 install pynvim
gem install neovim
yarn global add neovim

mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

mkdir -p ~/.local/share/zsh
curl -L git.io/antigen > ~/.local/share/zsh/antigen.zsh

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/dein-installer.sh
sh /tmp/dein-installer.sh ~/.cache/dein

./link.sh
