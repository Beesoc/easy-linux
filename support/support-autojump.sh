#!/bin/bash
# Version: 0.0.2
# Shellcheck source=/opt/easy-linux/.envrc
scripts_dir=/opt/easy-linux
# Shellcheck source=${scripts_dir}/.envrc
# Shellcheck source=source ${scripts_dir}/menu-master.sh
set -e

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

if [[ -f $HOME/.zshrc ]]; then
	echo "[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh" >> $HOME/.zshrc
	echo "autoload -U compinit && compinit -u" >> $HOME/.zshrc
elif [[ -f $HOME/.bashrc ]]; then
	echo "[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh" >> $HOME/.bashrc
	echo "autoload -U compinit && compinit -u" >> $HOME/.bashrc
fi
autoj_install=1
sudo sed -i "s/airj_install=.*/autoj_install-$autoj_install/g" "${scripts_dir}/.envrc"
if [[ -d $HOME/compiled/autojump ]]; then
sudo rm -rf $HOME/compiled/autojump
fi
source ${scripts_dir}/install/menu-master.sh
