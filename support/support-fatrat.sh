#!/bin/bash
# The Fat Rat installer/runner
# Version: 0.0.2

set -e
source ${scripts_dir}/.envrc

run_func() {
	sudo gnome-terminal -t "TheFatRat 1.9.5" --geometry=600x630 -e "bash -c 'fatrat';-bash"
}

app-install_func() {
	if [[ ! -d "$HOME/compiled/TheFatRat/" ]]; then
		sudo git clone https://github.com/Screetsec/TheFatRat.git &&
			cd TheFatRat &&
			sudo chmod +x setup.sh &&
			sudo ./setup.sh
	elif [[ -d "$HOME/compiled/TheFatRat/" ]]; then
		read -n 1 -r -p "The Fat Rat installation folder exists. Remove folder and reinstall?" reinstall
		reinstall={$reinstall:-Y}
		if [[ "$reinstall" =~ ^[Nn]$ ]]; then
			printf "${RED} The Fat Rat will not be installed. Press ${WT}any ${RED} key to return to Hacking Menu."
			read -r -n 1 -s -t 300
			source $scripts_dir/install/menu-hacking.sh
		elif [[ "$reinstall" =~ ^[Yy]$ ]]; then
			sudo rm -fR $HOME/compiled/TheFatRat
		else
			printf "${YW}    Invalid Selection."
		fi
	fi
	sudo git clone https://github.com/Screetsec/TheFatRat.git &&
		cd TheFatRat &&
		sudo chmod +x setup.sh &&
		sudo ./setup.sh

}

main() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
      if [[ $(which fatrat) ]]; then
           printf "${GN}You already have ${WT}TheFatRat ${GN}Installed."
           run_func
      else
	      read -n 1 -r -p "Do you want to install the Fat Rat? [Y/n] " instfat
	instfat=${instfat:-Y}
		if [[ $instfat = "Y" ]] || [[ $instfat = "y" ]]; then
			app-install_func
			fatrat-inst=1
		else
			printf "${WT}  $USER ${RED}has selected to not install The Fat Rat.  Exiting\n"
			exit 0
		fi
      fi
	#sudo gnome-terminal -t "TheFatRat 1.9.5" --geometry=600x630 -e "bash -c 'fatrat';-bash"
	app-install_func
}

main
clear
source ${scripts_dir}/install/menu-hacking.sh
