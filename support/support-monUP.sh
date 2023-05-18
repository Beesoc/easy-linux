#!/bin/bash
# script to start wifi adapter in MONITOR mode.
set -e
# Version: 0.0.2
#
clear
source ${scripts_dir}/.envrc

select_adapt_func() {
adapterfull=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}')
printf "${LB}"
adapter_count=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' | grep -c "wl")
if [ "${adapter_count}" -eq 1 ]; then
        adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4, " " $5}')
        printf "  \\n${CY}You have ${WT}$adapter_count ${CY}wireless network adapter.\\n"
elif [[ $adapter_count -gt 1 ]]; then
adapter_choice=""
adapter=$(sudo airmon-ng | awk '/wl/ {print $2}')
source ${scripts_dir}/support/support-netadapter.sh
elif [[ $adapter_count -eq 0 ]]; then
    printf "  ${RED}WTF. You need wireless adapters for monitor mode.\\n "
    printf "  NOTE: Wifi devices ${WT}cannot be passed through a Virtual Machine${RED}. Wifi adapters\\n"
    printf "  passed though from a host are identified as Ethernet Adapters. ${WT}Not Compatible${RED}."
fi 
}

execute_func() {
printf "${CY} "
clear
source "${scripts_dir}/support/support-Banner_func.sh"
printf " \\n"
printf "    ${OG}Randomizing MAC address & killing interfering processes \\n"
sudo ifconfig ${adapter} down
sudo macchanger -a ${adapter}

sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
sudo airmon-ng check
sudo airmon-ng check kill
printf "    ${WT}Bringing up monitor mode wifi adapter, ${CY}${adapter}${WT}.\\n${OG} "



adapter_choice=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' | cut -d' ' -f1 | sed -n "${selection}p")
sudo echo $adapter_choice >"${scripts_dir}/support/adapter_choice"
#    adapter=$(sudo airmon-ng | awk '  /wl/ { print $2 }')
sudo airmon-ng start ${adapter}
printf "   ${OG}-"
clear
printf " \n"
printf "   \n"
printf "  ${OG}Your MAC address has been changed and your wifi adapter, ${WT}${adapter}${OG}\\n"
printf " is in ${WT}monitor mode. ${RED}[*!*] Happy hacking [*!*]${OG}\\n"
printf " \\n"
printf "  When finished, ${RED}access the hacking menu ${OG}to set everything \\n"
printf " back to their original values.\\n${NC}"
printf "   \\n"

sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
clear
bash ${scripts_dir}/menu-master.sh
