#!/bin/bash
#shellcheck source=${scripts_dir}/.envrc
#shellcheck source=${scripts_dir}/support/support-Banner_func.sh
#shellcheck source=${scripts_dir}/support/support-Prompt_func.sh
scripts_dir=/opt/easy-linux
set -e
source "${scripts_dir}/.envrc"

trap source ${scripts_dir}/support/support-trap-wifi.sh EXIT

# Version: 0.0.3
scripts_dir=/opt/easy-linux
backup_dir=/opt/backup

hosts_func() {
        printf "${GN}20]  ${CY}Edit your local ${WT}/etc/hosts ${CY}file to keep DNS happy and ${CY} \\n "
	printf "     refer to machines by hostname instead of IP.\\n"
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	sudo apt update >/dev/null
	sudo apt install -y mdns nano >/dev/null
	sudo nano /etc/hosts
	sudo systemctl restart dnsmasq.service
	sudo systemctl restart NetworkManager.service
	sudo systemctl restart wpa_supplicant.service
}

ncdu_func(){
	printf "   ${OG}Searching for ${WT}ncdu${CY}. If found, I'll run ncdu. If not, I'll install it.\\n"
	sleep 1
	if [[ $(command -v ncdu >/dev/null 2>&1) ]]; then
		printf "${WT}ncdu ${CY}is installed\\n"
	else
		printf "${WT}ncdu ${CY}is not installed. Installing now.\\n"
		sleep 1
		printf "${GN}Please wait\\n"
		sleep 1
		printf "${GN}...\\n"
                sudo apt install -y ncdu >/dev/null
		fi
	fi
		sudo ncdu --color dark -ex --exclude-caches --exclude-kernfs --confirm-quit --exclude .cache --exclude os-iso --excude delme /
		return 0
}

timezone_func() {
	printf "${CY}  Fix Timezone and Time issues in Kali Linux. \\n "
	printf "TODO \\n"
}

locate_func() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "\\n      ${OG}[*] ${CY}pLocate: Find files and apps in an instant with pLocate.${GN} \\n\\n    "
	read -p "What do you want to search for? ----> " search
	clear
	printf " ${WT}"
	plocate $search
	printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
	read -r -n1 -s -t 120
}

perm_func() {
	printf "${OG}  3]  ${CY}Fix your perm - Permission probems in Linux can be a bitch.  Get help here. \\n "
	printf "${OG}  a]  ${CY}Fix permissions problems on ${WT}/opt/backup ${CY}and your ${WT}Home folder${CY} \\n  "
	printf "${OG}  b]  ${CY}Enter a custom folder to fix permissions on."
	source "${scripts_dir}/support/support-fix-my-perm.sh"
}

x11vnc_func() {
	sudo apt install -y x11vnc >/dev/null
	printf "${WT}  1]  ${CY}Start ${GN}x11vnc Server${CY} - Control PC remotely ${CY} \\n   "
	x11vnc -noxdamage -ncache 10 -ncache_cr -rfbauth ~/.vnc/passwd
}

main_menu_func() {
source ${scripts_dir}/menu-master.sh
}

main_menu() {
        clear
        source ${scripts_dir}/support/support-Banner_func.sh
        echo
        printf "${OG}          $USER               ${GN}Customization Station${OG}                 $computername ${CY}\n"
        echo
        printf "    ${GN}Select an option:${CY}\n"
        echo
        printf "    ${WT}1)${CY}  Start x11vnc Server${PL}: \\n"
        printf "    ${WT}2)${CY}  Fix Timezone and Time issues${PL}: ${CY}\n"
        printf "    ${WT}3)${CY}  Fix your Perm${PL}: Permission issues in Linux\n"
        printf "    ${WT}4)${CY}  Find things FAST with pLocate${PL}: \n"
        printf "    ${WT}5)${CY}  Edit HOSTS file${PL}: \n"
        printf "    ${WT}6)${CY}  Disk Space Mgmt with ${WT}ncdu${PL}: \n"
        printf "    ${WT}7)${CY}  Return to Main Menu${PL}\n"
        printf "    ${WT}8)${CY}  [✘] Exit tool [✘]\n"
        echo
        printf "    ${GN}Selection: ${CY}\n"
        read -n 1 -r main_menu_sel
        case "$main_menu_sel" in
        1) x11vnc_func ;;
        2) timezone_func ;;
        3) perm_func ;;
        4) locate_func ;;
        5) hosts_func ;;
        6) ncdu_func ;;
        7) main_menu_func ;;
        8) exit 0 ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
        esac
}

main() {
        # Main script logic

        while true; do
                main_menu
		printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
		read -n 1 -r
        done
}

main
source "${scripts_dir}/menu-master.sh"
