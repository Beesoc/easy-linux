#!/bin/bash
#
set -e
# Version 0.0.2
scripts_dir=/opt/easy-linux
clear
#
source "${scripts_dir}/.envrc"
source "${scripts_dir}/support/support-Banner_func.sh"
#trap ${scripts_dir}/support/support-trap-wifi.sh EXIT

run_nano_func() {
	sudo nano -ADEGHKMPSWZacegmpqy%_ -T 4
	source ${scripts_dir}/menu-master.sh
}

install_nano() {

	curl https://www.nano-editor.org/dist/v7/nano-7.2.tar.xz --output $HOME/Downloads/nano-7.2.tar.xz
	tar -xvf $HOME/Downloads/nano-7.2.tar.xz
	cd $HOME/Downloads/nano-7.2 || exit
	sudo .configure
	sudo make
	sudo make check
	nano_installed=1
	sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" ${scripts_dir}/.envrc
}

nano_check_deps() {

	if [[ -f /usr/local/bin/nano ]]; then
		printf "  ${CY}You already have ${WT}nano ${CY}installed.\\n"
		printf "  Would you like to install the latest version of ${WT}nano ${CY}from source?\\n  ${NC}"
		read -n 1 -r -p "Do you want to install the newest version of nano? [Y/n] " choicenano
		choicenano=${choicenano:-Y}
		clear
		source ${scripts_dir}/support/support-Banner_func.sh
		if [[ "$choicenano" = "N" ]] || [[ "$choicenano" = "n" ]]; then
			printf "  ${WT}$USER ${RED}has selected to ${WT}NOT upgrade nano${RED}. Exiting.\\n"
			exit 0
		else
			printf "  ${WT}Nano ${CY}will be upgraded or ${WT}reinstalled${CY}.\\n     "
		fi
	else
		printf "  ${USER}, you do not appear to have nano installed."
		read -n 1 -r -p "Do you want me to install it? [Y/n] " installnano
		installnano=${installnano:-Y}
		if [[ "$installnano" = "N" ]] || [[ $installnano = "n" ]]; then
			printf "${WT}$USER ${RED}has selected to ${WT}NOT install nano${RED}. Exiting.\\n ${NC}"
			exit 0
		elif [[ "$installnano" = "Y" ]] || [[ $installnano = "y" ]]; then
			install_nano
		else
			printf "${RED}  Invalid Selection.\\n"
		fi
	fi

	nano_installed=1
	sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" ${scripts_dir}/.envrc

}

main() {

	EXECUTABLE=$(which nano)
	if [[ -n $EXECUTABLE ]] && [[ $nano_installed = 1 ]]; then
		printf "  ${CY}Nano already installed!\\n"
		run_nano_func
	fi

	if [[ -n $EXECUTABLE ]]; then
		printf "  ${CY}Nano already installed!\\n"
		run_nano_func
	else
		nano_check_deps
	fi

	if [[ $nano_installed -ne 1 ]] && [[ $nano_installed -ne 0 ]]; then
		nano_installed=0
		sudo echo "export nano_installed=$nano_installed" >>${scripts_dir}/.envrc
		sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" ${scripts_dir}/.envrc
		nano_check_deps
	fi

	if [[ -d /usr/local/bin/nano ]]; then
		printf "  ${CY}Nano already installed. Exiting\\n"
		nano_installed=1
		sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" ${scripts_dir}/.envrc
		exit 0
	elif [[ ! -d /usr/local/bin/nano ]]; then
		nano_installed=0
		sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" ${scripts_dir}/.envrc
		nano_check_deps
	fi
}

main
source ${scripts_dir}/menu-master.sh
exit 0
