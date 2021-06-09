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

# ohmyzsh
touch $HOME/.user_path
sh zsh/install-ohmyzsh.sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
ln -f zsh/zshrc $HOME/.zshrc
ln -f zsh/zprofile $HOME/.zprofile

# pyenv
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
source $HOME/.zshrc
source $HOMR/.zprofile
pyenv install 3.8.10
pyenv global 3.8.10
pip install ptpython flake8 yapf thefuck

# autojump
git clone git://github.com/wting/autojump.git $HOME/autojump
$HOME/autojump/install.py

# vim
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
python $HOME/.vim/bundle/YouCompleteMe/install.py

# final config
if [ ! -d $HOME/.config/ptpython ] 
then 
    mkdir $HOME/.config/ptpython 
fi
./update.sh
exec zsh
