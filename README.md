# dotfiles

My dotfiles

## Prerequisites

Currently only macOS and Ubuntu (16.04+) is supported.

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

   This assumes you have already setup the necessary environment manually.

   If you want to setup a basic environment by installing necessary packages
   automatically, run

    ```sh
    $ ./install.sh
    ```

   The script will use the proper package manager on your system to install the
   packages (`apt` on Ubuntu/Debian. On macOS, it uses
   [Homebrew](https://brew.sh/)).  If Homebrew is not installed, it will be
   installed automatically.
