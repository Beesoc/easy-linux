#!/bin/bash
#
RED='\e[1;31m'
GN='\e[1;32m'
BL='\e[1;34m'
CY='\e[1;36m'
WT='\e[1;37m'
OG='\e[1;93m'
#
scripts_dir=${HOME}/scripts/

Prompt_func() {
  printf " \\n"
  printf "  ${GN}┌──(${BL}$USER㉿$HOSTNAME${GN})-[${WT}$(pwd)${BL}${GN}]\\n "
  printf " ${GN}L${BL}$ ${OG}"
#  printf " \\n "
}

Banner_func() {
  printf "${WT}
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
clear
Banner_func
printf "                          ${CY} Welcome to the Hacking/Security Menu.             ${OG}\\n  "
  printf "\\n  1] ${WT}[*] ${GN}Enable wifi Monitor mode ${OG}         20] ${GN}Enable wifi and Network Manager${OG} \\n"
  printf "  2] ${WT}[*] ${GN}Disable wifi Monitor mode${OG}         21] ${GN}Disable wifi and Network Manager${WT}\\n  "
  printf "  3]${WT}  Upload all hashes to wpa-sec and OHC "
  printf "\\n  "
  printf "  99] ${GN}Return to main menu${OG}                                   ${RED}[✘] Exit tool [✘]${OG}  \\n      "
  printf "\\n  "
  printf "\\n                     ${WT}[*] ${OG}NOTE: Monitor mode is required for Sniffing/Injecting${WT}\\n"
Prompt_func
read -r choice
if [[ ${choice} == 1 ]]; then  
    clear
    bash "${scripts_dir}"/install-monUP.sh
fi
if [[ "${choice}" == 2 ]]; then  
    clear
    bash "${scripts_dir}"/install-monDOWN.sh
fi
if [[ "${choice}" == 20 ]]; then  
    clear
    bash $"{scripts_dir}"/install-wpaUP.sh
fi
if [[ "${choice}" == 21 ]]; then  
    clear
    bash "${scripts_dir}"/install-wpaDOWN.sh
fi
if [[ "${choice}" == 3 ]]; then  
    clear
    bash "${scripts_dir}"/install-upload-hashes.sh
fi
exit
