#!/bin/bash
scripts_dir=/opt/easy-linux
set -e
# Version: 0.0.3
source "${scripts_dir}/.envrc"
trap ${scripts_dir}/support/trap-master.sh EXIT

duplicati_func() {

if [ ! -d $HOME/Downloads ]; then
     sudo mkdir $HOME/Downloads
elif [ -d $HOME/Downloads ]; then
	cd $HOME/Downloads || exit
      if [ ! -e $HOME/Downloads/duplicati_2.0.7.1-1_all.deb ]; then
		wget https://updates.duplicati.com/beta/duplicati_2.0.7.1-1_all.deb
      fi
   sudo dpkg -i ./duplicati_2.0.7.1-1_all.deb
   sudo rm ./duplicati_2.0.7.1-1_all.deb
   stand_install=1
   sudo sed -i "s/stand_install=.*/stand_install=$stand_install/g" "${scripts_dir}/.envrc"
fi
}

nano_lints_func() {
	printf "${OG}  Installing additional nano lints.${NC}\\n"
	if [[ -d ${compiled_dir} ]]; then
		printf " \\n"
		cd ${compiled_dir} || exit
		printf "  \\n"
	else
		mkdir ${compiled_dir} && cd ${compiled_dir}
	fi

	if [[ -d ${compiled_dir}/nanorc ]]; then
		sudo rm -Rf ${compiled_dir}/nanorc
		cd ${compiled_dir} || exit
		printf "  \\n"
	fi

	git clone https://github.com/scopatz/nanorc.git
	cd nanorc || exit
	sudo cp *.nanorc /usr/share/nano
	sudo cp ./shellcheck.sh /usr/bin
	sudo rm -Rf ${compiled_dir}/nanorc/

}

pack_sel_func() {
	# List of package names to install
	packages=("gawk" "libmono-2.0-1" "libayatana-appindicator1" "xterm" "aptitude" "autoconf" "automake" "bc" "libtool" "pkg-config" "libssl-dev" "ethtool" "geany" "geany-plugins" "htop" "shtool" "rfkill" "libpcap-dev" "libsqlite3-dev" "libhwloc-dev" "ncdu" "hostapd" "wpasupplicant" "tcpdump" "screen" "iw" "usbutils" "gtk-sharp2" "procps" "acpi" "pciutils" "groff")

	# Loop through the list of package names
	for package in "${packages[@]}"; do
		if dpkg -s ${package[@]} >/dev/null 2>&1; then
			printf "  ${GN} ${package[@]} is already installed\\n"
		else
			printf "  ${CY}Installing ${package[@]}${WT}\\n"
			sudo apt-get install -y "${package[@]}"
		fi
	done
	nano_lints_func
}

main() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
      printf "${YW}\\n\\n    ${WT} [***] ${YW}This menu contains software, and their dependencies, for\\n "
      printf "    some favs or that are required for other things that Linux Loader needs.\\n"
	printf "\\n${GN}    Should be safe installing anything here. ${WT}[***]\\n\\n    "

	read -n 1 -p "Do you want to continue? [Y/n] " choicefavs
	choicefavs=${choicefavs:-Y}

	if [[ "$choicefavs" =~ ^[Yy]$ ]]; then
      printf "Continuing...\\n"
            pack_sel_func
	      duplicati_func

      elif [[ "$choicefavs" =~ ^[Nn]$ ]]; then
		printf "${RED}Exiting.\\n"
		exit 0
	else 
	 	printf "${RED}  Invalid Selections. Please select Y or N only\\n"
	fi

	printf " ${OG}\\nInstalling Standard and Recommended favorite apps\\n"

}

if [[ ${stand_install} -eq 1 ]]; then
      return 0
else
	main
	printf "${CY}  All apps in this script have been successfully installed. ${PL}\\n"
    printf "${CY}  Loading Duplicati Backup solution in your web browser."
    echo
	printf "${OG}  Press ${WT}any ${OG}key to continue.\\n"

    
read -n 1 -s anykey
sudo duplicati &
exit 0
fi
