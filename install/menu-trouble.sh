#!/bin/bash
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT

placeholder3_func() {

}

placeholder2_func() {

}

timezone_func() {
	printf "${CY}  Fix Timezone and Time issues in Kali Linux. \\n "
	printf "TODO \\n"
}

placeholder1_func() {

}

perm_func() {
	printf "${OG}  3]  ${CY}Fix your perm - Permission probems in Linux can be a bitch.  Get help here. \\n "
	printf "${OG}  a]  ${CY}Fix permissions problems on ${WT}/opt/backup ${CY}and your ${WT}Home folder${CY} \\n  "
	printf "${OG}  b]  ${CY}Enter a custom folder to fix permissions on."
	source "${scripts_dir}/support/support-fix-my-perm.sh"
}

wifi_func() {
	${scripts_dir}/support/support-monitor
}

main_menu_func() {
	source ${scripts_dir}/install/menu-master.sh
}

main_menu() {
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
	echo
  printf "${OG}         $USER               ${GN}Troubleshooting War Room                    $computername\n"

	printf "  ${GN}Select an option:${CY}\n"
	echo
	printf "    ${WT}1)${CY}  WiFi problems${PL}: Services not starting? No WiFi? Stuck in Monitor mode?\n"
	printf "    ${WT}2)${CY}  Wibly Wobbley, Timey Whimy problems${PL}: Fix Timezone and Time issues${CY}\n"
	printf "    ${WT}3)${CY}  Fix your Perm${PL}: Permission issues in Linux\n"
	printf "    ${WT}4)${CY}  Coming Soon${PL}: \n"
	printf "    ${WT}5)${CY}  Coming Soon${PL}: \n"
	printf "    ${WT}6)${CY}  Coming Soon${PL}: \n"
	printf "    ${WT}7)${GN}  Return to Main Menu${PL}\n"
	printf "    ${WT}8)${RED}  [✘] Exit tool [✘]: Uhh, it just exits.\n"
	echo
	printf "  ${GN}Selection: ---->  ${OG}"
	read -n 1 -r trouble_menu
	case "$trouble_menu" in
	1) wifi_func ;;
	2) timezone_func ;;
	3) perm_func ;;
	4) placeholder1_func ;;
	5) placeholder2_func ;;
	6) placeholder3_func ;;
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
