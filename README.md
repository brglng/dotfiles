# dotfiles

My dotfiles.

Included software configrations:

- Alacritty
- Bash
- CGDB
- Git
- Neovim
- Tmux
- Vim
- Zsh

## Prerequisites

### Font

One of [Nerd Fonts](https://nerdfonts.com/) is required. In
config/alacritty/alacritty.yml, "FuraCode Nerd Font" is used. You can change
it to the font you like. If you use other terminal, please set the font by
yourself.

### Color

The [Nord](https://www.nordtheme.com/) color theme is used in Alacritty,
Neovim, Tmux, Vim and Zsh. You can change to other color themes if you are
familiar with the configration files.

### Operating System

The configurations and installation scripts are only tested on:

- Ubuntu 16.04
- Ubuntu 18.04
- macOS Mojave

If you found they work on your system, please report to me and I will add it
to the support list. If you found they do not work on your system, please feel
free to file an issue or PR to me. PRs are welcome and will be merged if they
LGTM, but issues are not guaranteed to get fixed if I don't get chance to test
on your environment.

## Installation

1. Clone and switch into the repository

       $ git clone --recursive --depth 1 https://github.com/brglng/dotfiles.git
       $ cd dotfiles

2. For full installation, run

       $ ./install.sh

   This will use the proper package manager on your system to install the
   necessary packages. On Ubuntu/Debian, `apt-get` is used. On macOS,
   [Homebrew](https://brew.sh/) is used, or installed if there is not an
   existing one.

   If you want to setup your environment manually and only want to link the
   configuration files, run

       $ ./link.sh

   This will overwrite your existing configuration files. The original files
   will be suffixed with `.orig`.
