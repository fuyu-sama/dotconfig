#!/usr/bin/env sh

dist=`awk -F= '$1=="ID" { print $2 ;}' /etc/os-release`

if [[ $dist == "debian" ]] || [[ $dist == "ubuntu" ]]
then
    sudo apt update
    sudo apt install zsh tmux make cmake neofetch
    # python build environment
    sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev \
        xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
elif [[ $dist == '"opensuse-leap"' ]] 
then
    sudo zypper install zsh tmux make cmake neofetch
    # python build environment
    sudo zypper install gcc automake bzip2 libbz2-devel xz xz-devel \
        openssl-devel ncurses-devel readline-devel zlib-devel tk-devel \
        libffi-devel sqlite3-devel

elif [[ $dist == "arch" ]]
then
    sudo pacman -S zsh tmux make cmake neofetch
    # python build environment
    sudo pacman -S --needed base-devel openssl zlib xz
fi

# vim
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# pyenv
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

# ohmyzsh
touch $HOME/.user_path
sh zsh/install-ohmyzsh.sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

exec zsh
if [ ! -d $HOME/.config/ptpython ] 
then 
    mkdir $HOME/.config/ptpython 
fi
pyenv install 3.8.10
pyenv global 3.8.10
pip install ptpython
pip install flask8
pip install yapf
pip install thefuck
./update.sh
