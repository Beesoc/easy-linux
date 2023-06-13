#!/bin/bash
#shellcheck source=${scripts_dir}/.envrc
#shellcheck source=${scripts_dir}/support/support-Banner_func.sh
#shellcheck source=${scripts_dir}/support/support-Prompt_func.sh
scripts_dir=/opt/easy-linux
set -e
source "${scripts_dir}/.envrc"
trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT

# Version: 0.0.3

_func() {

	printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
	read -n 1 -r
}

flaresolverr_func() {
docker run -d \
  --name=flaresolverr \
  -p 8191:8191 \
  -e LOG_LEVEL=info \
  --restart unless-stopped \
  ghcr.io/flaresolverr/flaresolverr:latest
	printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
	read -n 1 -r
}

hydra_func() {

	printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
	read -n 1 -r
}

john_func() {
	
	printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
	read -n 1 -r
}

hashcat_func() {

	printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
	read -n 1 -r
}

glances_func() {
      docker pull nicolargo/glances:latest-full
      printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
	read -n 1 -r
}

main_menu_func() {
	source ${scripts_dir}/install/menu-master.sh
}

main_menu() {
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
	echo
	printf "${OG}          $USER           ${GN}Damn I love App Containers${OG}                 ${computername} ${CY}\n"
	echo
	printf "  ${GN}Select an option:${CY}\n"
	echo
	printf "    ${WT}1)${CY}  Glances${PL}: Best sysinfo tool in the world.\n"
	printf "    ${WT}2)${CY}  Hashcat${PL}: With or without GPU support.\n"
	printf "    ${WT}3)${CY}  John the Ripper${PL}: \n"
	printf "    ${WT}4)${CY}  Hydra${PL}: \n"
	printf "    ${WT}5)${CY}  ${PL}: \n"
	printf "    ${WT}6)${CY}  ${PL}: \n"
	printf "    ${WT}7)${CY}  ${PL}: \n"
	printf "    ${WT}8)${CY}  ${PL}: \n"
	printf "    ${WT}9)${CY}  ${PL}: \n"
	printf "   ${WT}10)${CY}  ${PL}: \n"
	printf "   ${WT}11)${CY}  ${PL}: \n"
	printf "   ${WT}12)${CY}  ${PL}: \n"
	printf "   ${WT}13)${CY}  Flaresolverr${PL}: Cloudflare proxy for the arrr apps\n"
	printf "   ${WT}14)${CY}  ${PL}: \n"
      printf "   ${WT}15)${GN}  Return to Main Menu${PL}\n"
	printf "   ${WT}16)${RED}  [✘] Exit tool [✘]: Uhh, it just exits.\n"
	echo
	printf "  ${GN}Selection ${OG}----> "
	read -n 1 -r main_menu_sel
	case "$main_menu_sel" in
	1) glances_func ;;
	2) hashcat_func ;;
	3) john_func ;;
	4) hydra_func ;;
	5) _func ;;
	6) _func ;;
	7) _func ;;
	8) _func ;;
	9) _func ;;
	10) _func ;;
	11) _func ;;
	12) _func ;;
	13) flaresolverr_func ;;
	14) _func ;;
	15) main_menu_func ;;
	16) exit 0 ;;
	*) printf "${RED}Invalid selection.${CY}\n" ;;
	esac
}

main() {
	# Main script logic

if command -v docker >/dev/null || -d /opt/docker-desktop; then

	while true; do
		main_menu
		printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
		read -n 1 -r
	done

else
	printf "  ${RED}You are in the wrong place. Come see me after installing Docker.\\n"
	source ${scripts_dir}/support/support-docker.sh
fi
}

main
