# dotfiles
My dotfiles

## Prerequisites
- Vim 8.0 and [Neovim](https://neovim.io) in your system's package
repositories. For old Ubuntu versions that do not have Vim 8.0, you can use
[ppa:jonathonf/vim](https://launchpad.net/~jonathonf/+archive/ubuntu/vim).
For Neovim on Linux, please see
[Installing Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim).

## Installation

1. Clone and switch into the repository

    ```sh
    $ git clone --recursive https://github.com/brglng/dotfiles.git
    $ cd dotfiles
    ```

2. If you want only to link the configuration files, run

    ```sh
    $ ./link.sh
    ```

   This assumes you have already setup the necessary environment manually. If
   you want to setup a basic environment by installing necessary packages
   automatically, run

    ```sh
    $ ./install.sh
    ```

   The script will use the proper package manager on your system to install the
   packages (`apt` on Ubuntu/Debian and `yum` on Fedora/CentOS. On macOS, it
   uses [Homebrew](https://brew.sh/)).
