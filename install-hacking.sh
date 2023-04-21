#!/bin/bash
#
source .envrc


clear
source support/Banner_func.sh
printf "                     ${CY} Welcome to the Hacking/Security Menu.             ${OG}\\n  "
  printf "\\n  1] ${CY}Enable wifi Monitor mode ${OG}              20] ${CY}Enable wifi and Network Manager${OG} \\n"
  printf "\\n  2] ${CY}Disable wifi Monitor mode${OG}              21] ${CY}Disable wifi and Network Manager${OG}\\n"
  printf "\\n  3] ${CY}Upload all hashes to wpa-sec and OHC "
  printf "\\n\\n  "
  printf "${OG}[99] ${CY}Return to main menu${OG}                                       ${RED}[✘] Exit tool [✘]${OG}  \\n      "
  printf "\\n  "
  printf "\\n                         ${WT}[*] ${OG}NOTE: Monitor mode is required for Sniffing/Injecting${WT}\\n\\n"
Prompt_func
printf "    ----> "
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
