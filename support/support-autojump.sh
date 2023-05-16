#!/bin/bash
# Version 0.0.2
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
autoj_install=0
if [[ ! -d $HOME/compiled ]]; then
    mkdir $HOME/compiled
elif [[ -d $HOME/compiled ]]; then
    cd $HOME/compiled       
fi

if [[ -d $HOME/compiled/autojump ]]; then
        sudo rm -rf $HOME/compiled/autojump
elif [[ ! -d $HOME/compiled/autojump ]]; then
        printf "  Preparing for cloning."
fi
cd $HOME/compiled/
git clone https://github.com/wting/autojump.git
cd autojump
python3 ./install.py

sudo echo "[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh" >> ~/.zshrc
sudo echo "autoload -U compinit && compinit -u" >> ~/.zshrc
$autoj_install=1
sudo sed -i "s/airj_install=.*/autoj_install-$autoj_install/g" "${scripts_dir}/.envrc"
sudo rm -rf $HOME/compiled/autojump
source ${scripts_dir}/menu-master.sh
