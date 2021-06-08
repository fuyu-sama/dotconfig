#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
# update git repository
git pull origin
# ptpython
ln -f ptpython/config.py $HOME/.config/ptpython/config.py
ln -f ptpython/flake8 $HOME/.config/flake8
# tmux
ln -f tmux/tmux.conf $HOME/.tmux.conf
# vim
ln -f vim/vimrc $HOME/.vimrc
ln -f vim/tasks.ini $HOME/.vim/tasks.ini
[ -d $HOME/.vim/UltiSnips ] && rm $HOME/.vim/UltiSnips
ln -f -s $DIR/vim/UltiSnips $HOME/.vim/UltiSnips
# zsh
ln -f zsh/zshrc $HOME/.zshrc
ln -f zsh/zprofile $HOME/.zprofile
ln -f zsh/myys.zsh-theme $HOME/.oh-my-zsh/custom/themes/myys.zsh-theme
