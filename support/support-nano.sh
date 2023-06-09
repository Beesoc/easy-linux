#!/bin/bash
#
set -e
# Version: 0.0.3
scripts_dir=/opt/easy-linux
#
source "${scripts_dir}/.envrc"
#trap ${scripts_dir}/support/support-trap-wifi.sh EXIT

run_nano_func() {
	sudo nano -ADEGHKMPSWZacegmpqy%_ -T 4

}

install_nano() {

	curl https://www.nano-editor.org/dist/v7/nano-7.2.tar.xz --output $HOME/Downloads/nano-7.2.tar.xz
    cd $HOME/Downloads || exit
	tar -xvf $HOME/Downloads/nano-7.2.tar.xz
	cd $HOME/Downloads/nano-7.2 || exit
	./configure && make && sudo make install
	nano_installed=1
	sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" ${scripts_dir}/.envrc
}

nano_check_deps() {

	if [[ -f /usr/local/bin/nano ]]; then
		printf "  ${CY}You already have ${WT}nano ${CY}installed.\\n"
		printf "  Would you like to install the latest version of ${WT}nano ${CY}"
		read -n 1 -r -p "from source? [Y/n] ----> " choicenano
		choicenano=${choicenano:-Y}
		clear
		source ${scripts_dir}/support/support-Banner_func.sh
		if [[ "$choicenano" = "N" ]] || [[ "$choicenano" = "n" ]]; then
			printf "  ${WT}$USER ${RED}has selected to ${WT}NOT upgrade nano${RED}. Exiting.\\n"
			exit 0
		else
			printf "  ${WT}Nano ${CY}will be upgraded or ${WT}reinstalled${CY}.\\n     "
            install_nano
		fi
	else
		printf "  ${USER}, you do not appear to have nano installed.\\n"
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
		run_nano_func
	fi

	if [[ -n $EXECUTABLE ]]; then
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
