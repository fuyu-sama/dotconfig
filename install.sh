#!/usr/bin/env bash

if [ ! -d Downloads ]
then
    mkdir Downloads
fi
dist=`awk -F= '$1=="ID" { print $2 ;}' /etc/os-release`

if [[ $dist == "debian" ]] || [[ $dist == "ubuntu" ]]; then
    sudo apt update
    sudo apt install -y zsh tmux make cmake neofetch htop ncdu build-essential \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget \
        curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev libncurses5-dev libgtk2.0-dev libatk1.0-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev ruby-dev lua5.1 \
        liblua5.1-dev libperl-dev
elif [[ $dist == '"opensuse-leap"' ]]; then
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
elif [[ $dist == '"opensuse-tumbleweed"' ]]; then
    sudo zypper install -y zsh make cmake neofetch tmux htop ncdu gcc gcc-c++ \
        automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel \
        readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel libevent-devel
elif [[ $dist == "arch" ]]; then
    sudo pacman -Sy --needed zsh tmux make cmake neofetch htop ncdu base-devel \
        openssl zlib xz nnn python-pip
fi

# ohmyzsh
touch $HOME/.user_path
sh zsh/install-ohmyzsh.sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
./update.sh

# pyenv
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
source $HOME/.zprofile
export PYTHON_CONFIGURE_OPTS="--enable-shared"
INSTALL_PY_VERSION_SHORT=3.10
INSTALL_PY_VERSION=${INSTALL_PY_VERSION_SHORT}.9
pyenv install ${INSTALL_PY_VERSION}
pyenv global ${INSTALL_PY_VERSION}
pip install \
    ptpython flake8 yapf thefuck

# autojump
git clone https://github.com/wting/autojump.git Downloads/autojump
cd Downloads/autojump
./install.py
cd -

# vim
if ! [[ $dist == "arch" ]]; then
    export LDFLAGS="-rdynamic"
    git clone https://github.com/vim/vim.git Downloads/vim
    cd Downloads/vim
    ./configure --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp=yes \
        --enable-python3interp=yes \
        --with-python-config-dir=$HOME/.pyenv/versions/${INSTALL_PY_VERSION}/lib/python${INSTALL_PY_VERSION_SHORT}/config-${INSTALL_PY_VERSION_SHORT}-x86_64-linux-gnu \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
        --enable-cscope \
        --prefix=$HOME/.local/prefix/vim/9.0
    make && make install
    cd -
fi

git clone https://github.com/junegunn/vim-plug.git Downloads/vim-plug
[ ! -d $HOME/.vim/autoload ] && mkdir $HOME/.vim/autoload
cp Downloads/vim-plug/plug.vim $HOME/.vim/autoload
vim +PlugInstall +qall
python $HOME/.vim/plugged/YouCompleteMe/install.py
