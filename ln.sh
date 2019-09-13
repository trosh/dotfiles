#!/bin/sh

# !!! RUN THIS FROM THE DOTFILES DIRECTORY !!!

rel=$(realpath --relative-to="$HOME" "$PWD")

# Vim
ln -s "$rel/.vim" "$HOME"
ln -s ".vim/.vimrc" "$HOME"
# Xresources (URXVT)
ln -s "$rel/.Xresources" "$HOME"
xrdb -merge "$HOME/.Xresources"
# Tmux
ln -s "$rel/.tmux.conf" "$HOME"
# Bash
ln -s "$rel/.bashrc" "$HOME"
# Zsh
ln -s "$rel/.zshrc" "$HOME"
ln -s "$rel/.zfunctions" "$HOME"
# Git
ln -s "$rel/.gitconfig" "$HOME"
