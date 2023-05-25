#!/bin/bash
# Aircrack-ng installer/runner
# Version: 0.0.3
trap trap-master.sh EXIT

scripts_dir=/opt/easy-linux
source "${scripts_dir}/.envrc"
set -e

envrc_func() {
	# Update the .envrc file with the new values
	sudo sed -i "s/air_installed=.*/air_installed=$air_installed/g" "${scripts_dir}/.envrc"
	sudo sed -i "s/airc_deps_installed=.*/airc_deps_installed=$airc_deps_installed/g" "${scripts_dir}/.envrc"

      if [[ $(command -v direnv) ]]; then
	cd "${scripts_dir}/support" && direnv allow
      fi
	if [[ $airc_installed = 1 && $airc_deps_installed = 1 ]]; then
		printf "\\n${GN}  ${WT}Aircrack-ng ${CY}has been installed successfully.\\n"
	elif [[ $airc_installed = 0 && $airc_deps_installed = 1 ]]; then
		printf "\\n${GN}  ${WT}Aircrack-ng ${CY}is not reporting a successful install.\\n"
	elif [[ $airc_installed = 1 && $airc_deps_installed = 0 ]]; then
		printf "\\n${GN}  ${WT}Dependancies ${CY}are not reporting a successful install.\\n"
	else
		printf "\\n${GN}  ${WT}Can't determine installation status\\n"
	fi
}

aircrack_run_func() {
	# Run Aircrack-ng
	# Function 1
	if [[ $airc_installed -eq 1 && $airc_deps_installed -eq 1 ]]; then
		printf "\\n${GN}  Aircrack-ng is already installed.${CY}\\n"
		sudo aircrack-ng --help
		sudo aircrack-ng -u
		printf "Press any key to continue"
		read -n 1 -s -r -t 300
		clear
		envrc_func
		source ${scripts_dir}/menu-master.sh
		exit 0
	else
		printf "\\n${GN} Checking dependencies...\\n"
		airc_deps_installed=0
		sudo sed -i "s/airc_deps_installed=.*/airc_deps_installed=$airc_deps_installed/g" "${scripts_dir}/.envrc"
		deps_install_func

	fi

}

app_install_func() {

	if [[ ! -f $HOME/Downloads/aircrack-ng-1.7.tar.gz ]] && [[ ! -d $HOME/Downloads/aircrack-ng-1.7 ]]; then
		wget https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz -P "$HOME/Downloads"
		sudo tar -xvf $HOME/Downloads/aircrack-ng-1.7.tar.gz
		sudo rm $HOME/Downloads/aircrack-ng-1.7.tar.gz
		cd $HOME/Downloads/aircrack-ng-1.7
	elif [[ -f $HOME/Downloads/aircrack-ng-1.7.tar.gz ]] && [[ ! -d $HOME/Downloads/aircrack-ng-1.7 ]]; then
		cd $HOME/Downloads
		sudo tar -xvf $HOME/Downloads/aircrack-ng-1.7.tar.gz
		sudo rm $HOME/Downloads/aircrack-ng-1.7.tar.gz
		cd $HOME/Downloads/aircrack-ng-1.7
	fi

	if [[ -d $HOME/Downloads/aircrack-ng-1.7 ]]; then
		cd $HOME/Downloads/aircrack-ng-1.7

	fi

	sudo ./autogen.sh
	sudo make
	sudo make install
	airc_installed=1
	sudo sed -i "s/airc_installed=.*/airc_installed=$airc_installed/g" "${scripts_dir}/.envrc"
	# sudo echo "readonly airc_installed=1" >> ./support-airgeddon.sh
	aircrack_run_func

}

deps_install_func() {
	# Install dependencies and Aircrack-ng
	# function 3
	for packagedeps in build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool rfkill zlib1g-dev libpcap-dev libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant tcpdump screen iw usbutils; do
		if ! dpkg -s "$packagedeps" >/dev/null 2>&1; then
			airc_deps_installed=0
			printf "${CY}  $packagedeps is not installed.\\n"
			printf "${WT}  Installing $packagedeps...\\n"
			sudo apt-get update
			sudo apt-get install -y "$packagedeps"
		else
			printf "${GN} $packagedeps is installed.\\n"
			airc_deps_installed=1
		fi
	done

	airc_deps_installed=1
	sudo sed -i "s/airc_deps_installed=.*/airc_deps_installed=$airc_deps_installed/g" "${scripts_dir}/.envrc"

	app_install_func
}

# function 4
aircrack_check_func() {
	if [[ $airc_installed -eq 0 && $airc_deps_installed -eq 0 ]]; then
		deps_install_func
	fi
	if [[ $airc_installed -eq 1 && $airc_deps_installed -eq 1 ]]; then
		aircrack_run_func
	fi
	if [[ $airc_installed -eq 0 && $airc_deps_installed -eq 1 ]]; then
		app_install_func
	fi
	if [[ $airc_installed -eq 1 && $airc_deps_installed -eq 0 ]]; then
		deps_install_func
	fi
}

main() {
	# Prompt the user to install dependencies and Aircrack-ng
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
	printf "\\n "
	printf "\\n  ${GN}  Welcome to the Aircrack-ng installer.\\n"
	printf "${WT}    Please note that this script requires an active internet connection.\\n"
	printf "\\n${CY}    This script will install Aircrack-ng and its dependencies.\\n"
	printf "${GN}    "
	read -n 1 -s -r -p "Do you want to continue? [Y/n] " inst_airc
	inst_airc=${inst_airc:-Y}
	if [[ "$inst_airc" =~ ^[Nn]$ ]]; then
		printf "${GN}  Aborting installation.\\n"
		exit 0
	fi
	if [[ "${inst_airc}" =~ ^[Yy]$ ]]; then
		printf "${WT}\\n    This script requires ${WT}superuser privileges.\\n"
		printf "${WT}    Please enter your password if prompted.\\n"

		aircrack_check_func
	fi
}

main
airc_installed=1
sudo sed -i "s/airc_installed=.*/airc_installed=$airc_installed/g" "${scripts_dir}/.envrc"
source ${scripts_dir}/support/support-airgeddon.sh

exit 0
