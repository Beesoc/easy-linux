#!/bin/bash
# script to start wifi adapter in MONITOR mode.
set -e
# Version: 0.0.2
#
clear
source ${scripts_dir}/.envrc
adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}')
printf "${LB}"

adapter_choice=""
printf "${CY} -"
clear
source "${scripts_dir}/support/support-Banner_func.sh"
printf "         ${OG}Adapter Selection to ${WT}START Monitor mode${OG}. ${RED}Press ctrl+c to cancel.${NC}\\n"
# present a list of available WiFi adapters
adapter_count=$(sudo airmon-ng | awk '  /phy/ {print $2 " - " $4 " " $5}' | grep -c "phy")
#
trap ${scripts_dir}/support/support-trap-wifi.sh EXIT
if [ "${adapter_count}" -eq 1 ]; then
    adapter=$(sudo airmon-ng | awk '  /phywl/ {print $2 " - " $4, " " $5}')
else
    # If there are multiple wireless interfaces, prompt the user to select one
    printf "   \\n" 
    printf "${OG}    Multiple wireless interfaces available.${WT} \\n" 
    printf "${CY}    Please select one: \\n${OG}"
    sudo airmon-ng | awk '  /phy/ {print $2 " - " $4 " " $5}' 2> /dev/null | grep "phy" | nl -nln
    printf "   \\n  ${WT}" 
source "${scripts_dir}/support/support-Prompt_func.sh"
    read -r -p "  Enter the number of the interface you want to use in monitor mode: " selection
    adapter=$(sudo airmon-ng | awk '  /phy/ {print $2 " - " $4 " " $5}' | cut -d' ' -f1 | sed -n "${selection}p")
fi
#
clear
    source "${scripts_dir}/support/support-Banner_func.sh"
printf " \\n"
printf "    ${OG}Randomizing MAC address & killing interfering processes \\n"
printf "    ${WT}Bringing up monitor mode wifi adapter, ${CY}${adapter}${WT}.\\n${OG} "
sudo rm -f ${scripts_dir}/support/adapter 
adapter=$(sudo airmon-ng | awk '  /wl/ {print $2}')
sudo echo ${adapter} > ${scripts_dir}/support/adapter
sudo ifconfig ${adapter} down
sudo macchanger -a ${adapter}
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
sudo airmon-ng check
sudo airmon-ng check kill

if [ "${adapter}" == "${selection}" ]; then
    adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}')
    printf "${BL}The network adapter name is ${WT}${selection}.\\n"
else
    # If the adapter is brought up under a different name
    printf "   \\n${OG}" 
    printf "${OG}    Network adapter changed name.${WT} \\n" 
    printf "${CY}  The network adapter's new name is: ${WT}${selection} \\n"
    sudo airmon-ng | awk '  /wl/ {print $2 " - " $4}' 2> /dev/null | grep "wlan" | nl -nln
    printf "   \\n  ${OG}" 
    adapter_choice=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' | cut -d' ' -f1 | sed -n "${selection}p")
fi
    sudo echo $adapter_choice > "${scripts_dir}/support/adapter_choice"
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
