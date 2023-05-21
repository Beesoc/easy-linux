#!/bin/bash
# Version: 0.0.2
# Airgeddon installer/runner
# shellcheck source=.envrc

set -e
scripts_dir=/opt/easy-linux
source /opt/easy-linux/.envrc

run_airg_func() {
	if [[ $(command -v airgeddon >/dev/null 2>&1) ]] && [[ $airg_deps_inst = 1 ]]; then
		airg_installed=1
		export airg_installed=1

		sudo sed -i "s/airg_deps_inst=.*/airg_deps_inst=$airg_deps_inst/g" "${scripts_dir}/.envrc"
		sudo sed -i "s/airg_installed=.*/airg_installed=$airg_installed/g" "${scripts_dir}/.envrc"
	fi
	read -n 1 -s -t 300 -p "Press any key to continue "
	sudo /bin/bash airgeddon

	printf "${CY}  Press ${WT}any ${CY}"

	read -n 1 -s -t 300 -p "key to continue "
	printf "${CY}to the ${WT}Main Menu."
	source /opt/easy-linux/install/menu-master.sh
	exit 0
}

airg_install_func() {
	if [[ $airg_deps_inst = 0 ]]; then
		deps_airg_install
	elif [[ $airg_deps_inst = 1 ]]; then
		printf "  ${CY}Dependencies all installed.  Continuing.\\n"
	fi
	if [[ -d $HOME/Downloads/airgeddon ]]; then
		printf "   #{WT}Airgeddon ${GN}folder found."
	elif [[ ! -d $HOME/Downloads/airgeddon ]]; then
		git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git $HOME/Downloads/airgeddon
	fi

	# Airgeddon must be run with BASH shell, not SH
	cd $HOME/Downloads/airgeddon
	sudo /bin/bash airgeddon.sh
	airg_installed=1
	sudo sed -i "s/airg_installed=.*/airg_installed=$airg_installed/g" "${scripts_dir}/.envrc"
	run_airg_func
}

deps_airg_option() {
	optpackages=("wpaclean" "crunch" "aireplay-ng" "mdk4" "hashcat" "hostapd" "dhcpd" "isc-dhcp-server" "dhcp-server" "dhcp" "nft" "nftables" "iptables" "ettercap" "ettercap-text-only" "ettercap-graphical" "hashcat-utils" "etterlog" "lighttpd" "dnsmasq" "reaver" "wash" "bully" "pixiewps" "bettercap" "beef" "beef-xss" "beef-project" "packetforge-ng" "hostapd-wpe" "asleap" "john" "openssl" "hcxpcapngtool" "hcxtools" "hcxdumptool" "tshark" "wireshaek-cli")

	for optpackage in "${optpackages[@]}"; do
		if dpkg -s "$optpackages" >/dev/null 2>&1; then
			echo "$optpackages is already installed"
		else
			echo "Installing $optpackages"
			sudo apt-get install --ignore-missing -y "$optpackages"
		fi
		airg_deps_inst=1
		sudo sed -i "s/airg_deps_inst=.*/airg_deps_inst=$airg_deps_inst/g" "${scripts_dir}/.envrc"
	done
	airg_install_func
}

deps_airg_install() {
	# List of package names to install
	packages=("iw" "procps" "gawk" "xterm" "pciutils" "autoconf" "automake" "libtool" "pkg-config" "libnl-3-dev" "libnl-genl-3-dev" "libssl-dev" "ethtool" "shtool" "rfkill" "zlib1g-dev" "libpcap-dev" "libsqlite3-dev" "libpcre3-dev" "libhwloc-dev" "libcmocka-dev" "hostapd" "wpasupplicant" "tcpdump" "screen" "iw" "usbutils" "airodump-ng" "groff")

	# Loop through the list of package names
	for package in "${packages[@]}"; do
		if dpkg -s "$package" >/dev/null 2>&1; then
			echo "$package is already installed"
		else
			echo "Installing $package"
			sudo apt-get install --ignore-missing -y "$package"
		fi
		airg_deps_inst=1
		sudo sed -i "s/airg_deps_inst=.*/airg_deps_inst=$airg_deps_inst/g" "${scripts_dir}/.envrc"
	done
	deps_airg_option
}

deps_airg_check() {
	printf "\\n${GN} Checking dependencies...\\n"
	if [[ "${airg_deps_inst}" = 1 ]]; then
		printf "  ${WT}$Airgeddon dependencies ${CY}are installed.  Continuing...\\n"
		airg_install_func
	elif [[ "${airg_deps_inst}" = 0 ]]; then
		printf "  ${WT}Airgeddon dependencies ${CY}not installed.  Installing...\\n"
	fi
	#  install Deps - Aircrack-ng check
	#  install Deps - airgeddon
	if [[ "$airg_deps_inst" == 0 ]]; then
		deps_airg_install
	elif [[ "$airg_deps_inst" == 1 ]]; then
		airg_install_func
	fi
}

main() {
	# Check for aircrack-ng installation
	clear
	source ${scripts_dir}/support/support-Banner_func.sh

	# Check for airgeddon installation

	if [[ -f /opt/easy-linux/.envrc ]]; then
		airg_installed=$(grep "airg_installed" /opt/easy-linux/.envrc | cut -d "=" -f 2)
		if [[ $airg_installed -eq 1 ]]; then
			printf "${GN}Airgeddon is already installed. Skipping installation.\\n"
			run_airg_func
		fi
		if [[ $airg__deps_inst -eq 0 ]]; then
			printf "${OG}Airgeddon dependencies not installed. Installing...\\n"
			if [[ $airg_deps_inst = 1 ]]; then
				airg_install_func
			elif [[ $airg_deps_inst = 0 ]]; then
				airc_installed=$(grep "airc_installed" /opt/easy-linux/.envrc | cut -d "=" -f 2)
				if [[ $airc_installed -eq 1 ]]; then
					printf "Aircrack-NG is already installed. Skipping installation.\\n"
					deps_airg_install
				elif [[ $airc_deps_inst = 0 ]]; then
					source ${scripts_dir}/support/support-aircrack2.sh
					deps_airg_install
				fi
			fi
		fi
	fi

	if [[ -d $HOME/Downloads/airgeddon ]]; then
		printf "Airgeddon download folder found. Continuing...\\n"
		if [[ $airg_installed -eq 1 ]]; then
			printf "${GN}Aircrack-ng is already installed. Skipping installation.\\n"
			run_airg_func
		else
			printf "${OG}Airgeddon dependencies not installed. Installing...\\n"
			deps_airg_check
			#source /opt/easy-linux/support/support-aircrack2.sh
		fi

	fi
}

main
