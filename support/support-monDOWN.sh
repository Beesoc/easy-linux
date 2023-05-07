#!/bin/bash
# script to start wifi adapter in MANAGED mode.
set -e
source ${scripts_dir}/.envrc
#
source "${scripts_dir}/support/support-Banner_func.sh"
original_adapter=$(cat ${scripts_dir}/support/adapter)
clear
printf "\n   "
printf "\n"
#	printf "  ${ORANGE}Adapter selection to STOP Monitor Mode. ${RED}Press ctrl+c to cancel.${NC}\n"
	adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4}')
#	if [ "${adapter_count}" -eq 1 ]; then
#		adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4}')
#	else
#	  # If there are multiple wireless interfaces, prompt the user to select one
#		printf "   \n"
#		printf "${ORANGE}    Multiple wireless interfaces are available.${WHITE} \\n" 
#		printf "\\n${BLUE}    Please select one: \\n \\n${LIGHTBLUE}"
#		printf ${adapter} | grep 'wl' | nl -nln
	#    sudo airmon-ng | awk '  /mon/ {print $2 " - " $4}' 2> /dev/null | grep "mon" | nl -nln
#		printf "   \\n  ${ORANGE}" 
#		read -r -p "  Enter the number of the interface you want to set back to Managed mode: " selection
	#    adapter=$(hcxdumptool -I 2> /dev/null | grep "phy" | cut -d' ' -f1 | sed -n "${selection}p")
	#    adapter=$(sudo airmon-ng | awk ' /mon/ {print $2 $4}' | cut -d' ' -f1 | sed -n "${selection}p")
#	fi
	#
printf "    \n"
printf "   \n"
printf "    ${ORANGE}Restoring MAC address & original Networking & Wifi processes \\n"
printf "    ${WHITE}Stopping Monitor mode & bringing up ${WHITE}${original_adapter} ${ORANGE}in ${WHITE}managed mode.${ORANGE}\\n"
sudo airmon-ng stop ${adapter}
sudo ifconfig ${original_adapter} down
sudo macchanger -p ${original_adapter}
sudo ifconfig ${original_adapter} up
printf "   ${ORANGE}"
clear
printf " \n"
printf "    \n"    
printf "    ----------------------------------------------------------------------\n"
printf " \\n"
printf "      ${ORANGE}Your MAC address has been restored and your wifi adapter,\\n"
printf "      ${WHITE}${original_adapter}${ORANGE} is in ${WHITE}Managed mode${ORANGE}. \\n"
sudo rm -f ./support/adapter ./support/adapter_choice
printf " \\n"
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
printf "    ----------------------------------------------------------------------\n"
