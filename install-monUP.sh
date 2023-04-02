#!/bin/bash
# script to start wifi adapter in MONITOR mode.
set -e
#
RED='\e[1;31m'
GN='\e[1;32m'
YW='\e[1;33m'
BL='\e[1;34m'
CY='\e[1;36m'
WT='\e[1;37m'
OG='\e[1;93m'
LB='\e[0;34m'
NC='\e[0m'
#
clear
adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}')
printf "${LB}"

Prompt_func() {
  printf " \\n"
  printf "  ${GN}┌──(${BL}$USER㉿$HOSTNAME${GN})-[${WT}$(pwd)${BL}${GN}]\\n "
  printf " ${GN}L${BL}$ ${OG}"
#  printf " \\n "
}

Banner_func() {
  printf "${WT}\\n
-------------------------------------------------------------------------------${CY}
  ▄████▄╗    ▄████▄╗   ▄████▄╗    ▄████▄╗     ▄███▄╗     ▄███▄╗  ██╗  ▄████▄╗  
  ██═══██╝   ██╔═══╝   ██╔═══╝   ██╔════╝    ██╔══██╗   ██╔══▀╝   ▀╝ ██╔════╝  
  ██████╝    █████╗    █████╗     ▀████▄╗    ██║  ██║   ██║           ▀████▄╗  
  ██═══██    ██╔══╝    ██╔══╝      ╚═══██║   ██║  ██╝   ██║  ▄╗        ╚═══██║ 
  ▀████▀╝    ▀████▀╗   ▀████▀╗    ▀████▀╝     ▀███▀╝     ▀███▀╝       ▀████▀╝  
   ╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝
  ▄████▄╗   ▄█▄╗    ▄███▄╗ █▄╗   ▄█╗   ▄█╗    ▄█╗ ▄█╗  █▄╗ ▄█╗  ▄█╗ ██▄╗  ▄██╗ 
  ██╔═══╝  ██║██╗  ██╔═══╝  ██╗ ██╔╝   ██║    ██║ ██▄╗ ██║ ██║  ██║  ▀██▄██▀╝  
  █████╗  ███▀███╗  ▀███▄╗   ████╔╝    ██║    ██║ ████▄██║ ██║  ██║    ███║    
  ██╔══╝  ██║  ██║   ╚══██║   ██╔╝     ██║    ██║ ██║▀███║ ██║  ██║  ▄██▀██▄╗  
  ▀████▀╝ ██║  ██║  ▀███▀╝    ██║      ▀████╗ ██║ ██║  ██║  ▀███▀╝  ██▀╝  ▀██╗ 
   ╚═══╝  ╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═══╝ ╚═╝ ╚═╝  ╚═╝   ╚═╝    ╚═╝    ╚═╝ ${WT}
------------------------------------------------------------------------------- \\n"
  #
#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
}

adapter_choice=""
printf "${CY} -"
clear
Banner_func
printf "         ${OG}Adapter Selection to ${WT}START Monitor mode${OG}. ${RED}Press ctrl+c to cancel.${NC}\\n"
# present a list of available WiFi adapters
adapter_count=$(sudo airmon-ng | awk '  /phy/ {print $2 " - " $4 " " $5}' | grep -c "phy")
#
if [ "${adapter_count}" -eq 1 ]; then
    adapter=$(sudo airmon-ng | awk '  /phywl/ {print $2 " - " $4, " " $5}')
else
    # If there are multiple wireless interfaces, prompt the user to select one
    printf "   \\n" 
    printf "${OG}    Multiple wireless interfaces available.${WT} \\n" 
    printf "${CY}    Please select one: \\n${OG}"
    sudo airmon-ng | awk '  /phy/ {print $2 " - " $4 " " $5}' 2> /dev/null | grep "phy" | nl -nln
    printf "   \\n  ${WT}" 
Prompt_func
    read -r -p "  Enter the number of the interface you want to use in monitor mode: " selection
    adapter=$(sudo airmon-ng | awk '  /phy/ {print $2 " - " $4 " " $5}' | cut -d' ' -f1 | sed -n "${selection}p")
fi
#
clear
Banner_func
printf " \\n"
printf "    ${OG}Randomizing MAC address & killing interfering processes \\n"
printf "    ${WT}Bringing up monitor mode wifi adapter, ${CY}${adapter}${WT}.\\n${OG} "
sudo rm ./support/adapter 
adapter=$(sudo airmon-ng | awk '  /wl/ {print $2}')
sudo echo ${adapter} > ./support/adapter
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
    sudo echo $adapter_choice > ./support/adapter_choice
#    adapter=$(sudo airmon-ng | awk '  /wl/ { print $2 }')
sudo airmon-ng start ${adapter}
printf "   ${OG}-"
clear
printf " \n"
printf "   \n"
printf "   ${OG}------------------------------------------------------------------------\n${OG}"
printf "    \n"
printf "  ${OG}Your MAC address has been changed and your wifi adapter, ${WT}${adapter}${OG}\\n" 
printf " is in ${WT}monitor mode. ${RED}[*!*] Happy hacking [*!*]${OG}\\n"
printf " \\n"
printf "  When finished, ${RED}run \'install-monDOWN.sh\' ${OG}to set everything \\n"
printf " back to their original values.\\n${NC}"
printf "   \\n"

sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
printf "${OG}   ------------------------------------------------------------------------"
clear
bash ${HOME}scripts/install-master.sh
