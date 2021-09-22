#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
# update git repository
git pull origin

# check whether dirs exist
DIRS[0]=$HOME/.config
DIRS[1]=$HOME/.config/ptpython
DIRS[2]=$HOME/.vim
for i in ${DIRS[@]}
do
    if [ ! -d $i ] 
    then 
        mkdir $i
    fi
done

# ptpython
ln -f $DIR/ptpython/config.py $HOME/.config/ptpython/config.py
ln -f $DIR/ptpython/flake8 $HOME/.config/flake8
# tmux
ln -f $DIR/tmux/tmux.conf $HOME/.tmux.conf
ln -f $DIR/tmux/ewrap $HOME/.ewrap
# vim
ln -f $DIR/vim/vimrc $HOME/.vimrc
ln -f $DIR/vim/tasks.ini $HOME/.vim/tasks.ini
[ -d $HOME/.vim/UltiSnips ] && rm $HOME/.vim/UltiSnips
ln -f -s $DIR/vim/UltiSnips $HOME/.vim/UltiSnips
# zsh
ln -f $DIR/zsh/zshrc $HOME/.zshrc
ln -f $DIR/zsh/zprofile $HOME/.zprofile
ln -f $DIR/zsh/p10k.zsh $HOME/.p10k.zsh
ln -f $DIR/zsh/myys.zsh-theme $HOME/.oh-my-zsh/custom/themes/myys.zsh-theme
