#!/bin/bash
#shellcheck source=${scripts_dir}/.envrc
#shellcheck source=${scripts_dir}/support/support-Banner_func.sh
#shellcheck source=${scripts_dir}/support/support-Prompt_func.sh
source "${scripts_dir}/.envrc"
# Version: 0.0.2

clear
source "${scripts_dir}/support/support-Banner_func.sh"
printf "                    ${OG}[?]${CY} Customization: Please select an option: ${OG}[?] \\n\\n"
printf "  ${OG} 1] ${GN}Start x11vnc Server${WT} [Remote Access]${OG}            ${GN}20] ${GN}Edit${WT} HOSTS ${GN}file \\n${WT}"
printf "  ${OG} 2] ${GN}Fix Timezone & ${WT}Time issues ${GN}in Kali${OG}             ${GN}21] ${GN}Manage ${WT}Disk Space\\n"
printf "  ${OG} 3] ${GN}Fix your perm! ${WT}Permissions fixes${OG}                             \\n"
printf "  ${OG} 4] ${WT}Find things${GN} on your machine FAST with plocate ${NC}\\n \\n"
printf "  ${OG}99] ${GN}Return to ${WT}main menu                           ${RED} [✘] Exit tool [✘]${NC}\\n"
printf " \\n\\n"
source "${scripts_dir}/support/support-Prompt_func.sh"
printf "${GN}   ----->${CY} "
# Read user input and display the appropriate submenu
read -r choice
printf "  ${LB}\\n"
if [[ ${choice} == 1 ]]; then
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	sudo apt install -y x11vnc >/dev/null
	printf "${WT}  1]  ${CY}Start ${GN}x11vnc Server${CY} - Control PC remotely ${CY} \\n   "
	x11vnc -noxdamage -ncache 10 -ncache_cr -rfbauth ~/.vnc/passwd
elif [[ ${choice} == 2 ]]; then
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "${CY}  2]  Fix Timezone and Time issues in Kali Linux. \\n "
	printf "TODO \\n"
elif [[ ${choice} == 3 ]]; then
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "${OG}  3]  ${CY}Fix your perm - Permission probems in Linux can be a bitch.  Get help here. \\n "
	printf "${OG}  a]  ${CY}Fix permissions problems on ${WT}/opt/backup ${CY}and your ${WT}Home folder${CY} \\n  "
	printf "${OG}  b]  ${CY}Enter a custom folder to fix permissions on."
	source "${scripts_dir}/support/support-fix-my-perm.sh"
elif [[ ${choice} == 4 ]]; then
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "\\n      ${OG}[*] ${CY}pLocate: Find files and apps in an instant with pLocate.${GN} \\n\\n    "
	read -p "What do you want to search for? ----> " search
	clear
	printf " ${WT}"
	plocate $search
	printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
	read -r -n1 -s -t 120
elif [[ ${choice} == 20 ]]; then
	printf "${GN}20]  ${CY}Edit your local ${WT}/etc/hosts ${CY}file to keep DNS happy and ${CY} \\n "
	printf "     refer to machines by hostname instead of IP."
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	sudo apt update >/dev/null
	sudo apt install -y mdns nano >/dev/null
	sudo nano /etc/hosts
	sudo systemctl restart dnsmasq.service
	sudo systemctl restart NetworkManager.service
	sudo systemctl restart wpa_supplicant.service
elif [[ ${choice} == 21 ]]; then
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "${GN}[21] ${CY}Check Disk Usage ${OG}quickly and easily with ${WT}ncdu${CY} \\n "
	printf "   ${OG}Searching for ${WT}ncdu${CY}. If found, I'll run ncdu. If not, I'll install it.\\n"
	sleep 1
	if command -v ncdu >/dev/null 2>&1; then
		printf "${WT}ncdu ${CY}is installed"
	else
		printf "${WT}ncdu ${CY}is not installed. Installing now.\\n"
		sleep 1
		printf "${GN}Please wait"
		sleep 1
		printf "${GN}...\\n"
		sudo apt update >/dev/null
		printf "${GN}...\\n"
		sudo apt install -y ncdu >/dev/null
	fi
	sudo ncdu -x --exclude-caches --exclude-kernfs /
elif [[ ${choice} == 99 ]]; then
	printf "${YW}      You chose System Information. \\n "
	clear
	#    Sysinfo_menu
	source "${scripts_dir}/support/support-Banner_func.sh"
	source "${scripts_dir}/support/support-sysinfo.sh"
elif [[ ${choice} == 0 ]]; then
	#    Exit_menu
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "${RED}0. [✘] Exit tool [✘]${NC} \\n      "
	exit 1
else
	printf "${RED}  Invalid Selection."
fi

printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
read -r -n 1 -s -t 120
source "${scripts_dir}/menu-master.sh"
