#!/bin/sh

# !!! RUN THIS FROM THE DOTFILES DIRECTORY !!!

rel=$(realpath --relative-to="$HOME" "$PWD")

# Vim
ln -s "$rel/vim" "$HOME/.vim"
ln -s ".vim/vimrc" "$HOME/.vimrc"
# Xresources (URXVT)
ln -s "$rel/Xresources" "$HOME/.Xresources"
xrdb -merge "$HOME/.Xresources"
# Tmux
ln -s "$rel/tmux.conf" "$HOME/.tmux.conf"
# Bash
ln -s "$rel/bashrc" "$HOME/.bashrc"
# Zsh
ln -s "$rel/zshrc" "$HOME/.zshrc"
ln -s "$rel/zfunctions" "$HOME/.zfunctions"
# Git
ln -s "$rel/gitconfig" "$HOME/.gitconfig"
