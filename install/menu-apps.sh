#!/bin/bash
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
clear
#
source ${scripts_dir}/.envrc
source ${scripts_dir}/support/.whoami.sh
install_apps_func() {
	clear

	options=("All" "Aircrack-NG" "Airgeddon" "Docker Desktop" "Main Menu" "My Favs" "Nano" "TheFatRat" "Hacking Tool" "System Info" "Webmin" "WiFite" "Exit")

	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "\\n                ${OG}Select which app you would like to install.${GN}\\n\\n"

	coloredEcho "Green ECHO" green

	select option in "${options[@]}"; do
		case ${option} in

		"Airgeddon")
			clear
			source "${scripts_dir}/support/support-Banner_func.sh"
			printf "${GN}\\n  You've selected ${WT}Airgeddon${CY}.\\n    "
			if [[ $airg_installed = 1 ]]; then
				sudo airgeddon
				airg_installed=1
				sudo sed -i "s/airg_installed=.*/airg_installed=$airg_installed/g" "${scripts_dir}/.envrc"
			else
				read -n 1 -p "Do you want to continue? [Y/n] " choiceairged
				choiceairged=${choiceairged:-Y}
			fi
			if [[ "$choiceairged" =~ ^[Yy]$ ]]; then
				printf "${GN}  Continuing...\\n"
			elif [[ "$choiceairged" =~ ^[Nn]$ ]]; then
				printf "${RED}  Cancelling. Returning to ${WT}Main Menu\\n"
				source ${scripts_dir}/support/support-airgeddon.sh
			else
				printf "${RED}  Exiting.\\n"
				exit 0
			fi
			source ${scripts_dir}/support/support-airgeddon.sh
			;;
		"Aircrack-NG")
			clear
			source "${scripts_dir}/support/support-Banner_func.sh"
			if [[ $(command -v aircrack-ng >/dev/null 2>&1) ]] && [[ $airc_installed = 1 ]]; then
				printf "${GN}Aircrack-NG is already installed\\n"
				sudo aircrack-ng --help
				airc_installed=1
				sudo sed -i "s/airc_installed=.*/airc_installed=$airc_installed/g" "${scripts_dir}/.envrc"
			else
				printf "${YW}Aircrack-NG is not installed. Installing\\n"
				source ${scripts_dir}/support/support-aircrack2.sh
			fi
			;;
		"Docker Desktop")
			clear
			if [[ $(command -v /opt/docker-desktop/bin/docker-desktop >/dev/null 2>&1) ]]; then
				docker_installed=1
				printf "${GN}Docker Desktop is already installed\\n"
				sudo /opt/docker-desktop/bin/docker-desktop
				sudo sed -i "s/docker_installed=.*/docker_installed=$docker_installed/g" "${scripts_dir}/.envrc"
			else
				printf "${YW}Docker Desktop is not installed. Installing\\n"
				source ${scripts_dir}/support/support-docker.sh
			fi
			;;
		"Hacking Tool")
			if [[ $hacktool-installed = 0 ]]; then
				source ${scripts_dir}/support/support-hackingtool.sh
			elif [[ $hacktool-installed = 1 ]]; then
				sudo hackingtool
				hacktool_installed=1
				sudo sed -i "s/hacktool_installed=.*/hacktool_installed=$hacktool_installed/g" "${scripts_dir}/.envrc"
				exit 0
			fi
			;;
		"TheFatRat")
			clear
			source ${scripts_dir}/support-support-Banner_func.sh
			if [[ $(command -v fatrat >/dev/null 2>&1) ]] && [[ $fatrat_installed = 1 ]]; then
				printf "\\n${GN}The Fat Rat is already installed\\n"
				sudo fatrat
				fatrat_installed=1
				sudo sed -i "s/fatrat_installed=.*/fatrat_installed=$fatrat_installed/g" "${scripts_dir}/.envrc"
			else
				source ${scripts_dir}/support/support-fatrat.sh
			fi
			;;
		"My Favs")
			if [[ $stand_installed = 0 ]]; then
				source ${scripts_dir}/support/support-inst-standard.sh
			elif [[ $stand_installed = 1 ]]; then
				printf "${OG}  You have already installed all of the standard tools.\\n"
				stand_installed=1
				sudo sed -i "s/stand_installed=.*/stand_installed=$stand_installed/g" "${scripts_dir}/.envrc"
				exit 0
			fi
			;;
		"Main Menu")
			printf "${OG}You selected ${WT}Main Menu\\n${CY}"
			source ${scripts_dir}/menu-master.sh
			;;
		"Nano")
		    nano_exe=$(which nano)
			clear
			if [[ $nano_installed = 1 ]]; then
				sudo nano -ADEGHKMPSWZacdegmpqy%_ -T 4 
				sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" "${scripts_dir}/.envrc"
            fi

			if [[ $nano_installed = 0 ]] && [[ -n $nano_exe ]]; then
                nano_installed=1
				sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" "${scripts_dir}/.envrc"
                sudo nano -ADEGHKMPSWZacdegmpqy%_ -T 4 

            fi

			if [[ $nano_installed = 0 ]]; then
				source $scripts_dir/support/support-nano.sh
			fi
			;;
		"System Info")
			clear
			source "${scripts_dir}/support/support-Banner_func.sh"
			source "${scripts_dir}/support/support-sysinfo.sh"
			;;
		"Webmin")
			clear
			source "${scripts_dir}/support/support-Banner_func.sh"

			if [[ $(command -v webmin >/dev/null 2>&1) ]] && [[ $webmin_installed = 1 ]]; then
				printf "${OG}  Webmin already installed. Access via web browser at:\\n${WT} "
				printf "https://localhost:10000\\n"
				printf "  ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
				read n 1 -t 300
				webmin_installed=1
				sudo sed -i "s/webmin_installed=.*/webmin_installed=$webmin_installed/g" "${scripts_dir}/.envrc"

			fi
			if [[ $webmin_installed = 0 ]]; then
				source ${script_dir}/support/support-webmin.sh
			fi
			;;
		"Wifite")
			clear
			source "${scripts_dir}/support/support-Banner_func.sh"
			if [[ $(command -v wifite >/dev/null 2>&1) ]] && [[ $wifite_installed = 1 ]]; then
				printf "\\n${GN}Wifite is already installed\\n"
				sudo wifite
				sudo sed -i "s/wifite_installed=.*/wifite_installed=$wifite_installed/g" "${scripts_dir}/.envrc"
			else
				printf "    \\n${YW}Wifite is not installed\\n"
				source "${scripts_dir}/support/support-wifite.sh"
				wifite_installed=1
			fi
			;;
		"All")
			printf "${PL}       You chose ${WT}All.\\n\\n"
			printf "${PL}   Depending on speed of ${WT}PC and Internet${PL}, this may take a while${YW}\\n  "
			read -n 1 -s -p "Are you sure you want to install All? [Y/n] " all_installed
			all_installed=${all_installed:-Y}
			if [[ $all_installed = "N" ]] || [[ $all_installed = "n" ]]; then
				printf "${OG}    ${WT}$USER ${OG}has selected to cancel ${WT}'Install All' ${OG}option".
				exit 0
			elif [[ $all_installed = "Y" ]] || [[ $all_installed = "y" ]]; then
				# Loop through all options and perform the action
				for o in "${options[@]:0:12}"; do
					printf "${OG}Performing action for ${WT}$o${CY}"
					# Perform action here
				done
			fi
			break
			;;
		"Exit")
			clear
			printf "   ${RED}You selected Exit${OG}\\n"
			exit 0
			;;
		*)
			printf "${RED}Invalid option entered.\\n  ${GN}Please try again.\\n${CY}"
			;;
		esac
	done
}

personal_func() {
	if [[ $USER = "beesoc" ]] && [[ $HOST = "updates" ]]; then
		source ${scripts_dir}/support/support-updates.sh
	else
		exit 0
	fi
}

deps_install_func() {
	# List of package names to install
	packages=("ccze" "colorized-logs" "xrootconsole" "xdpyinfo / x11-utils / xorg-xdpyinfo" "iw" "iproute2 / ip" "awk / gawk" "autoconf" "automake" "libtool" "pkg-config" "rfkill" "libpcap-dev" "lsusb / usbutils" "wget" "ethtool" "loginctl / systemd" "grep" "uname" "sed" "hostapd" "wpasupplicant" "screen" "groff")

	# Loop through the list of package names
	for package in "${packages[@]}"; do
		if dpkg -s "$package" >/dev/null 2>&1; then
			echo "$package is already installed"
		else
			echo "Installing $package"
			sudo apt-get install -y "$package"
		fi
		menu_apps_deps=1
		sudo sed -i "s/menu-apps-deps=.*/menu-apps-deps=$menu-apps-deps/g" "${scripts_dir}/.envrc"
		install_apps_func
	done
}

main() {

	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "\\n              ${CY}First, we will ${WT}update/upgrade ${CY}all packages.\\n"
	printf "\\n                    ${RED}[!!!] ${YW}IMPORTANT CHOICE ${RED}[!!!]\\n "
	printf "\\n             ${CY}Enter the ${WT}C ${CY}key to continue for ${GN}ANYTHING EXCEPT${CY} a Pwnagotchi.\\n"
	printf "     ${GN}---->   ${CY}If you're using a Pwnagotchi, enter P to continue.${NC}\\n${CY}"
	printf "\\n         ${RED}[!!!] ${YW}DONT UPDATE/UPGRADE A PWNAGOTCHI, ENTER P ${RED}[!!!]${NC}\\n"
	printf "\\n      ${WT}[P]${GN}wnagotchi ${CY}or ${WT}[C]${GN}ontinue ${CY}with ANY other Linux distro? ----> "
	read -n 1 -r installchoice
	if [[ ${installchoice} = "c" ]] || [[ ${installchoice} = "C" ]]; then
		installchoice=${installchoice:-P}
		sudo apt update
		updates=$(sudo apt list --upgradable | wc -l)
		security_updates=$(sudo apt list --upgradable 2>/dev/null | grep -E '\[security|critical\]' | wc -l)
		security_pct=$(echo "scale=2; ($security_updates/$updates)*100" | bc)
		printf "  ${CY}You have ${updates} updates available, of which ${security_updates} are security related or severe.\\n"
		printf "  ${CY}Please wait. This step may take ${WT}several minutes ${CY}depending on your internet speed!\\n"
		if (($(echo "$security_pct >= 20" | bc -l))); then
			printf "${RED}Security updates represent 20 percent or more of available updates.  Performing upgrade. "
			sudo apt upgrade -y
		elif (($(echo "$security_pct <= 20" | bc -l))); then
			printf "\\n${GN}Security updates represent 20 percent or less of available updates.  Perform upgrade? [Y/n] "
			read -n 1 -r perfupgrade
			perfupgrade=${perfupgrade:-Y}
			if [[ $perfupgrade == "n" ]] || [[ $perfupgrade == "N" ]]; then
				printf "  ${RED}Your system is at severe risk. Updates should be installed soon."
			elif [[ $perfupgrade == "y" ]] || [[ $perfupgrade == "Y" ]]; then
				sudo apt upgrade -y
			fi
		fi
	elif [[ ${installchoice} = "p" ]] || [[ ${installchoice} = "P" ]]; then
		deps_install_func
	fi

	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "\\n                   ${CY}Summary of changes made by this script.${WT}   \\n"
	printf "              [ Update/Upgrade all packages ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"
	sleep 1
	printf "                      [ Install HackingTool ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"
	sleep 1
	printf "              [ Docker Desktop Dependencies ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"
	sleep 1
	printf "                   [ Install Docker Desktop ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"
	sleep 1
	printf "                          [ Install Wifite2 ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"
	sleep 1
	printf "                         [ Install HCXTools ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"
	sleep 1
	printf "                      [ Install The Fat Rat ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"
	sleep 1
	printf "            [ Install Additional Nano Lints ].....${GN}[✔] Successfully Installed [✔]${CY}\\n"
	sleep 1
	read -n 1 -p "Press M to return to main menu or X to Exit. [M/x]" menuchoice
	menuchoice=${menuchoice:-M}
	if [[ ${menuchoice} = "m" ]] || [[ ${menuchoice} = "M" ]]; then
		source ${scripts_dir}/menu-master.sh
	elif [[ ${menuchoice} = "x" ]] || [[ ${menuchoice} = "X" ]]; then
		printf " \\n"
		exit 0
	else
		printf " ${RED}  Invalid Selection"
	fi
}
main
