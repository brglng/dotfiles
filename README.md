# dotfiles

My dotfiles

## Prerequisites

The configurations and installation scripts are only tested on:

- Ubuntu 16.04
- Ubuntu 18.04
- macOS Mojave

If you found they work on your system, please report to me and I will add it
to the support list. If you found they do not work on your system, please feel
free to file an issue or PR to me. PRs are welcomed and will be merged if they
LGTM, but issues are not guaranteed to get fixed.

## Installation

1. Clone and switch into the repository

       $ git clone --recursive --depth 1 https://github.com/brglng/dotfiles.git
       $ cd dotfiles

2. For full installation, run

       $ ./install.sh

   This will use the proper package manager on your system to install the
   necessary packages. On Ubuntu/Debian, `apt-get` is used. On macOS,
   [Homebrew](https://brew.sh/) is used, or installed if there is no existing
   one.

   If you want to setup your environment manually and only want to link the
   configuration files, run

       $ ./link.sh

   This will overwrite your existing configuration files. The original files
   will be renamed with a `.orig` suffix.
