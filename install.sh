#!/bin/sh
set -e

install_yum() {
  :
}

install_apt() {
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt-get update

  sudo apt-get install -y build-essential g++ gdb clang automake autoconf libtool pkg-config make cmake git global ripgrep python3-pip python3-dev vim-gtk3 zsh tmux neovim luajit libluajit-5.1-dev ruby-dev

  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt-get install yarn
}

install_linux() {
  distname=$(cat /etc/*release | sed -ne 's/DISTRIB_ID=\(.*\)/\1/gp')
  distver=$(cat /etc/*release | sed -ne 's/DISTRIB_RELEASE=\(.*\)/\1/gp')
  machine=$(uname -m)

  case $(distname) in
    Ubuntu) install_apt ;;
    Debian) install_apt ;;
    Fedora) install_yum ;;
    CentOS) install_yum ;;
  esac

  # install Universal Ctags
  rm -rf /tmp/ctags
  git clone --depth=1 --recursive https://github.com/universal-ctags/ctags.git /tmp/ctags
  pushd /tmp/ctags
  ./autogen.sh
  ./configure --prefix=~/.local
  make
  make install
  popd

  # install CCLS
  sudo apt install zlib1g-dev libncurses-dev
  rm -rf /tmp/ccls
  git clone --depth=1 --recursive https://github.com/MaskRay/ccls /tmp/ccls
  pushd /tmp/ccls
  wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
  tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
  cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$PWD/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04 -DCMAKE_INSTALL_PREFIX=~/.local
  cmake --build Release
  make install
  popd

  pip3 install neovim
  gem install neovim
}

install_mac() {
  if which brew; then
    brew update
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew install coreutils make automake autoconf libtool pkg-config make cmake global ripgrep sk python python3 tmux luajit reattach-to-user-namespace yarn ccls
  brew install vim --with-override-system-vi --with-gettext --with-python3 --with-luajit
  brew install neovim --HEAD
  brew cask install macvim
  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags
}

./link.sh

case $(uname -s) in
  Linux) install_linux ;;
  Darwin) install_mac ;;
esac

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
rustup component add rls rust-analysis rust-src

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
nvm install --latest npm node
nvm use node
nvm alias default node

mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

mkdir -p ~/.local/share/zsh
curl -L git.io/antigen > ~/.local/share/zsh/antigen.zsh
zsh -c 'source ~/.zshrc && antigen update'

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/dein-installer.sh
sh /tmp/dein-installer.sh ~/.cache/dein

# mkdir -p ~/.local/src
# git clone -b stable https://github.com/rust-lang/rust.git ~/.local/src/rust
