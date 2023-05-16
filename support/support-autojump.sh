#!/bin/bash
# Version 0.0.2
# Shellcheck source=/opt/easy-linux/.envrc
scripts_dir=/opt/easy-linux
# Shellcheck source=${scripts_dir}/.envrc
# Shellcheck source=source ${scripts_dir}/menu-master.sh

source ${scripts_dir}/.envrc
autoj_install=0
if [[ ! -d $HOME/compiled ]]; then
    mkdir $HOME/compiled
    elif [[ -d $HOME/compiled ]]; then
    cd $HOME/compiled || exit
fi

if [[ -d $HOME/compiled/autojump ]]; then
    sudo rm -rf $HOME/compiled/autojump
    elif [[ ! -d $HOME/compiled/autojump ]]; then
    printf "  Preparing for cloning."
fi
cd $HOME/compiled/ || exit
git clone https://github.com/wting/autojump.git
cd autojump || exit
python3 ./install.py

echo "[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh" >> $HOME/.zshrc
echo "autoload -U compinit && compinit -u" >> $HOME/.zshrc

echo "[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh" >> $HOME/.bashrc
echo "autoload -U compinit && compinit -u" >> $HOME/.bashrc
autoj_install=1
sudo sed -i "s/airj_install=.*/autoj_install-$autoj_install/g" "${scripts_dir}/.envrc"
sudo rm -rf $HOME/compiled/autojump
source ${scripts_dir}/menu-master.sh
