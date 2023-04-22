#!/bin/bash
#
source .envrc


clear
source support/Banner_func.sh
printf "                     ${CY} Welcome to the Hacking/Security Menu.             ${OG}\\n  "
  printf "\\n  ${OG}1] ${CY}Enable wifi Monitor mode ${OG}              20] ${CY}Enable wifi and Network Manager${OG} \\n"
  printf "\\n  ${OG}2] ${CY}Disable wifi Monitor mode${OG}              21] ${CY}Disable wifi and Network Manager${OG}\\n"
  printf "\\n  ${OG}3] ${CY}Upload all hashes to wpa-sec and OHC${OG}   22] ${CY}Capture Hashes ${OG}\\n"
  printf "\\n  ${OG}4] ${CY}Use Beesoc's wordlist or merge ${OG}          \\n" 
  printf "    lists, sort and eliminate dups with 1 easy tool."
  printf "\\n\\n  "
  printf "${OG}[90]${WT}[!!!] ${CY}Awesmome, must-try functionality. Try the happily homicidal kill-bot, AutoHack 5000 ${WT}[!!!]"
  printf "${OG}[99] ${CY}Return to main menu${OG}                                       ${RED}[✘] Exit tool [✘]${OG}  \\n      "
  printf "\\n  "
  printf "\\n                         ${WT}[*] ${OG}NOTE: Monitor mode is required for Sniffing/Injecting${WT}\\n\\n"
  source support/Prompt_func.sh
printf "    -----> "
read -r choice
if [[ ${choice} == 1 ]]; then  
    clear
    bash support/install-monUP.sh
elif [[ "${choice}" == 2 ]]; then  
    clear
    bash support/install-monDOWN.sh
elif [[ "${choice}" == 20 ]]; then  
    clear
    bash support/install-wpaUP.sh
elif [[ "${choice}" == 21 ]]; then  
    clear
    bash support/install-wpaDOWN.sh
elif [[ "${choice}" == 22 ]]; then  
    clear
    bash ./install-hcxdump.sh
elif [[ "${choice}" == 90 ]]; then  
    clear
    bash ./install-hcxdump.sh
elif [[ "${choice}" == 3 ]]; then  
    clear
    bash ./install-upload-hashes.sh
elif [[ "${choice}" == 4 ]]; then  
    clear
    bash support/install-makeWordlist.sh
elif [[ "${choice}" = "x" ]] || [[ "${choice}" = "X" ]]; then  
    clear
    bash install-master.sh
else
    printf "${YW}  Nope, that's an invalid selection."
fi
exit 1
