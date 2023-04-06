#!/bin/bash

RED='\e[1;31m'
GN='\e[1;32m'
YW='\e[1;33m'
BL='\e[1;34m'
CY='\e[1;36m'
WT='\e[1;37m'
OG='\e[1;93m'
LB='\e[0;34m'
NC='\e[0m'

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
  Banner_func
  printf "                    ${OG}[?]${CY} Customization: Please select an option: ${OG}[?] \\n"
  printf "  ${OG} 1] ${GN}Start x11vnc Server [Remote Access]${OG}            ${GN}20] ${GN}Edit HOSTS file \\n${WT}"
  printf "  ${OG} 2] ${GN}Fix Timezone & Time issues in Kali${OG}             ${GN}21] ${GN}Manage Disk Space${RED} \\n"
  printf "  ${OG} 3] ${GN}Fix your perm! Permissions fixes  \\n"
  printf "  ${WT}99]${WT}  Return to main menu                         ${OG}${RED} [✘] Exit tool [✘]${NC}\\n"  
  Prompt_func
  
    printf "   ${YW}

  printf "6. ${WT}Find things${YW} on your machine FAST with plocate ${RED} \\n   "
  printf "0. [✘] Exit tool [✘]${NC} \\n  " 
  
# Read user input and display the appropriate submenu
read -r choice
  printf "  ${LB}\\n"
if [[ ${choice} == 1 ]]; then  
    clear
    printf "${YW}  1]  Start ${WT}x11vnc Server${YW} - Control PC remotely ${CY} \\n   "
    x11vnc -noxdamage -ncache 10 -ncache_cr -rfbauth ~/.vnc/passwd
fi
if [[ ${choice} == 2 ]]; then  
    clear
    printf "${YW}  2]  Fix Timezone and Time issues in Kali Linux. \\n "
    printf "TODO \\n"
fi
if [[ ${choice} == 3 ]]; then  
    clear
    Banner_func
    printf "${GN}  3]  Fix your perm - Permission probems in Linux can be a bitch.  Get help here. \\n "
    printf "${GN}  a]  Fix permissions problems on ${CY}/opt/backup ${GN}and your ${CY}Home folder${GN} \\n   "
    printf "${GN}  b]  Enter a custom folder to fix permissions on." 
    printf "TODO \\n"
fi
if [[ ${choice} == 20 ]]; then  
    printf "${GN}  20]  ${CY}Edit your local /etc/HOSTS file to keep DNS happy${YW} \\n "
    clear
    sudo apt update
    sudo apt install -y mdns nano
    sudo ncdu -x --exclude-caches --exclude-kernfs /  
fi
if [[ ${choice} == 21 ]]; then  
    printf "${GN}  21]  ${CY}Check Disk Usage ${OG}quickly and easily with ${WT}ncdu${YW} \\n "
    clear
    sudo apt update
    sudo apt install -y ncdu
    sudo ncdu -x --exclude-caches --exclude-kernfs /  
fi
if [[ ${choice} == 99 ]]; then  
    printf "${YW}      You chose System Information. \\n "
    clear
#    Sysinfo_menu
    Banner_func
    printf "Show sys info"
fi
if [[ ${choice} == 0 ]]; then  
#    Exit_menu
    clear
    Banner_func
    printf "${RED}0. [✘] Exit tool [✘]${NC} \\n      "
    exit



Prompt_func() {
  printf " \\n"
  printf "  ${GN}┌──(${BL}$USER㉿$HOSTNAME${GN})-[${WT}$(pwd)${BL}${GN}]\\n "
  printf " ${GN}L${BL}$ ${OG}"
#  printf " \\n "
}

Banner_func
printf "${OG} \\n"
printf "You have entered the Customize menu.  Press any key to exit"
Prompt_func
read -r -n1 -s -t 10

  printf "  ${LB}\\n"

  }

exit
