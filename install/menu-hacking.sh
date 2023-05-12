#!/bin/bash
#
# Version: 0.0.2

source ${scripts_dir}/.envrc
set -e 
trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT
clear
source "${scripts_dir}/support/support-Banner_func.sh"
printf "                     ${CY} Welcome to the Hacking/Security Menu.             ${OG}\\n  "
  printf "\\n  ${OG}1] ${CY}Enable wifi Monitor mode ${OG}              20] ${CY}Enable wifi and Network Manager${OG} \\n"
  printf "\\n  ${OG}2] ${CY}Disable wifi Monitor mode${OG}              21] ${CY}Disable wifi and Network Manager${OG}\\n"
  printf "\\n  ${OG}3] ${CY}Upload all hashes to wpa-sec and OHC${OG}   22] ${CY}Capture Hashes ${OG}\\n"
  printf "\\n  ${OG}4] ${CY}Use Beesoc's wordlist or merge ${OG}        23] ${CY}Wifite: PMKID, EAPOL, WPS attacks  \\n" 
  printf "    lists, sort and delete dups with 1 easy tool."
  printf "\\n\\n"
  printf "${OG}[90] ${WT}[!!!] ${CY}Try the new AutoHack ${WT}[!!!]\\n"
  printf "${OG}[99] ${CY}Return to main menu${OG}                                       ${RED}[✘] Exit tool [✘]${OG}  \\n      "
  printf "\\n  "
  printf "\\n                         ${WT}[*] ${OG}NOTE: Monitor mode is required for Sniffing/Injecting${WT}\\n\\n"
printf "      -----> "
read -r choice
if [[ ${choice} == 1 ]]; then
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-monUP.sh"
elif [[ "${choice}" == 2 ]]; then  
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-monDOWN.sh"
elif [[ "${choice}" == 3 ]]; then  
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/menu-upload-hashes.sh"
elif [[ "${choice}" == 4 ]]; then  
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-makeWordlist.sh"
elif [[ "${choice}" == 20 ]]; then  
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-wpaUP.sh"
elif [[ "${choice}" == 21 ]]; then  
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-wpaDOWN.sh"
elif [[ "${choice}" == 22 ]]; then  
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-hcxdump.sh"
elif [[ "${choice}" == 23 ]]; then  
    source "${scripts_dir}/support/support-wifite.sh"
elif [[ "${choice}" == 90 ]]; then  
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-hcxdump.sh"
elif [[ "${choice}" == 99 ]]; then  
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/menu-master.sh"
elif [[ "${choice}" = "x" ]] || [[ "${choice}" = "X" ]]; then  
    clear
    exit 0
else
    printf "${RED}  Nope, that's an invalid selection."
fi
clear
source "${scripts_dir}/menu-master.sh"
