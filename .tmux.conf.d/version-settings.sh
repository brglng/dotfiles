#!/bin/bash
if [[ $(echo "$(tmux -V | cut -d' ' -f2) >= 2.1" | bc -l) -eq 1 ]]; then
  tmux source ~/.tmux.conf.d/ge-2.1.conf
else
  tmux source ~/.tmux.conf.d/lt-2.1.conf
fi
