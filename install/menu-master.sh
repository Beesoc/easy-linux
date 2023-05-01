#!/bin/bash
#
# 1st release of Beesoc's Easy Linux Loader
# * Defines a series of color codes for printing output in different colors.
# * Defines several variables that point to other shell scripts.
# * Defines two functions: Prompt_func(), which prints a command prompt with some information about the user & current  \\n
#   directory, and Banner_func(), which prints a banner at the top of the screen.
# * Displays a main menu with four options: Hacking, Customize, Downloads, and Pwnagotchi. The user can select an option 
#   by typing the corresponding number.
#
#printf "${BG}"
# shellcheck source=support/support-Prompt_func.sh
# shellcheck source=.envrc
# shellcheck source=support/support-Banner_func.sh
# Version: 0.0.2
source .envrc
set -e
#source "support/support-Prompt_func.sh"
scripts_dir="/opt/easy-linux"

function show_help {
  echo "Usage: $SCRIPT_NAME [OPTIONS]"
  echo
  echo "Options:"
  echo "  -h, --help    Show this help message and exit"
  echo "  -v, --version Show the version number and exit"
}

main() {
# Display the main menu
  clear
  source support/support-Banner_func.sh
  printf "                       ${OG}[???]${CY} Please select an option: ${OG}[???]${CY}\\n  \\n"
  printf "  ${OG}1] ${GN}Hacking${OG}                         3] ${GN}Apps and Downloads \\n${WT}\\n"
  printf "  ${OG}2] ${GN}Customize${OG}                       4] ${GN}Pwnagotchi${RED} \\n"
  printf "  ${OG}\\n"
  printf "  ${OG}98]${GN} I have no wifi! reset wifi stuff" 
  printf "  ${OG}99]${GN} Display System Information                                 ${RED} [✘] Exit tool [✘]${NC}\\n"  
  printf " \\n"
  source support/support-Prompt_func.sh
  printf "     ---->  "
# Read user input and display the appropriate submenu
read -r choice
  printf "  ${LB}\\n"
#  printf "  ${LB}\\n"
if [[ ${choice} == 1 ]]; then  
    clear
    source support/support-Banner_func.sh
    printf "${YW}\\n\\n           You chose Hacking. [!!!]This menu is continually evolving.  \\n"
    printf "\\n           but know that you may experience bugs or other weird shit.  ${GN}You\\n"
    printf "\\n           have been warned. [!!!]\\n" 
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.\\n"
      read -r -n1 -s -t 60
      clear
      #    Hacking_menu
bash ${scripts_dir}/menu-hacking.sh
elif [[ ${choice} == 2 ]]; then  
    clear
    source support/support-Banner_func.sh
    printf "${YW}\\n\\n           You chose Customize. [!!!]This menu is coming soon. You can continue\\n"
    printf "\\n           but know that you may experience bugs or other weird shit.  ${GN}You\\n"
    printf "\\n           have been warned. [!!!]\\n" 
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.\\n"
      read -r -n1 -s -t 60
      clear
     source support/support-Banner_func.sh 
#    Customize_menu
    bash ./menu-customize.sh
elif [[ ${choice} == 3 ]]; then  
    clear
    printf "${YW}\\n\\n           You chose Apps and Downloads. [!!!]This menu is coming soon. You can continue\\n"
    printf "\\n           but know that you may experience bugs or other weird shit.  ${GN}You\\n"
    printf "\\n           have been warned. [!!!]\\n" 
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.${GN}\\n"
      read -r -n1 -s -t 60
      clear
      #    Download_menu
    bash ./menu-apps.sh
elif [[ ${choice} == 4 ]]; then  
    printf "${YW}      You chose Pwnagotchi. \\n "
    clear
#    Pwnagotchi_menu
    bash ./menu-backup_pwn-script.sh
elif [[ ${choice} == 98 ]]; then  
    printf "${YW}      You chose Wifi problems. Playing with these menus can occassionally\\n "
    printf "${YW}      leave your wifi adaptors and network services in varying states.\\n"
    printf "${YW}      This option will reset all nework adapters to managed mode and restart \\n"
    printf "${YW}      the NetworkManager and wpa_supplicant services."
    printf "\\n\\n      ${CY}Press ${WT}any ${CY}key to continue.${GN}"
      read -r -n1 -s -t 60
    #    Wifi_problems_menu
    trap "support/trap-wifi.sh" TRAP
elif [[ ${choice} == 99 ]]; then  
    printf "${YW}      You chose System Information. \\n "
    clear
#    Sysinfo_menu
    
    source "support/support-sysinfo.sh"
elif [[ ${choice} == 0 ]]; then  
#    Exit_menu
    clear
    source support/support-Banner_func.sh
    printf "${RED}0. [✘] Exit tool [✘]${NC} \\n"
    exit 1
else 
    printf "${RED}[!!!]${OG} Invalid Selection  ${RED}[!!!]"
fi
}
main
