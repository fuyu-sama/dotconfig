#!/usr/bin/env bash

if [ ! -d Downloads ]
then
    mkdir Downloads
fi
dist=`awk -F= '$1=="ID" { print $2 ;}' /etc/os-release`

if [[ $dist == "debian" ]] || [[ $dist == "ubuntu" ]]
then
    sudo apt update
    sudo apt install -y zsh tmux make cmake neofetch htop ncdu build-essential \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget \
        curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev libncurses5-dev libgtk2.0-dev libatk1.0-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev ruby-dev lua5.1 \
        liblua5.1-dev libperl-dev
elif [[ $dist == '"opensuse-leap"' ]]
then
    sudo zypper install -y zsh make cmake gcc-c++ gcc9 gcc9-c++ neofetch htop \
        ncdu automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel \
        readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel libevent-devel
    export CC=/usr/bin/gcc-9
    export CXX=/usr/bin/g++-9
    # tmux
    git clone https://github.com/tmux/tmux.git Downloads/tmux
    cd Downloads/tmux
    ./configure
    make && sudo make install
    cd -
elif [[ $dist == '"opensuse-tumbleweed"' ]]
then
    sudo zypper install -y zsh make cmake neofetch tmux htop ncdu gcc gcc-c++ \
        automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel \
        readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel libevent-devel
elif [[ $dist == "arch" ]]
then
    sudo pacman -Sy --needed zsh tmux make cmake neofetch htop ncdu base-devel \
        openssl zlib xz nnn
fi

# ohmyzsh
touch $HOME/.user_path
sh zsh/install-ohmyzsh.sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
./update.sh

# pyenv
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
source $HOME/.zprofile
export PYTHON_CONFIGURE_OPTS="--enable-shared"
pyenv install 3.8.10
pyenv global 3.8.10
pip install ptpython flake8 yapf thefuck

# autojump
git clone https://github.com/wting/autojump.git Downloads/autojump
cd Downloads/autojump
./install.py
cd -

# vim
export LDFLAGS="-rdynamic"
git clone https://github.com/vim/vim.git Downloads/vim
cd Downloads/vim
./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-python3interp=yes \
    --with-python-config-dir=$HOME/.pyenv/versions/3.8.10/lib/python3.8/config-3.8-x86_64-linux-gnu \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-cscope \
    --prefix=$HOME/.local/prefix/vim/8.2
make && make install
cd -

git clone https://github.com/junegunn/vim-plug.git Downloads/vim-plug
[ ! -d $HOME/.vim/autoload ] && mkdir $HOME/.vim/autoload
cp Downloads/vim-plug/plug.vim $HOME/.vim/autoload
vim +PlugInstall +qall
python $HOME/.vim/bundle/YouCompleteMe/install.py
