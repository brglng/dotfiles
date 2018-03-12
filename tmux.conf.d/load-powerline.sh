#!/bin/bash
powerline-daemon -q

if [ $(uname -s) = Darwin ]; then
  tmux source $HOME/Library/Python/3.6/lib/python/site-packages/powerline/bindings/tmux/powerline.conf
else
  if [ -e ~/.local/lib/python3.6/site-packages/powerline/bindings/tmux/powerline.conf ]; then
    tmux source $HOME/.local/lib/python3.6/site-packages/powerline/bindings/tmux/powerline.conf
  elif [ -e ~/.local/lib/python3.5/site-packages/powerline/bindings/tmux/powerline.conf ]; then
    tmux source $HOME/.local/lib/python3.5/site-packages/powerline/bindings/tmux/powerline.conf
  elif [ -e /usr/local/lib/python3.5/dist-packages/powerline/bindings/tmux/powerline.conf ]; then
    tmux source /usr/local/lib/python3.5/dist-packages/powerline/bindings/tmux/powerline.conf
  elif [ -e ~/.local/lib/python3.4/site-packages/powerline/bindings/tmux/powerline.conf ]; then
    tmux source $HOME/.local/lib/python3.4/site-packages/powerline/bindings/tmux/powerline.conf
  elif [ -e /usr/local/lib/python3.4/dist-packages/powerline/bindings/tmux/powerline.conf ]; then
    tmux source /usr/local/lib/python3.4/dist-packages/powerline/bindings/tmux/powerline.conf
  fi
fi
