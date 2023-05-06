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
scripts_dir="/opt/easy-linux"
# shellcheck source=${scripts_dir}/support/support-Prompt_func.sh
# shellcheck source=${scripts_dir}/.envrc
# shellcheck source=${scripts_dir}/support/support-Banner_func.sh
# Version: 0.0.2
source ${scripts_dir}/.envrc
set -e

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
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "                       ${OG}[???]${CY} Please select an option: ${OG}[???]${CY}     ${RED}[✘] Exit tool [✘] \\n \\n"
  printf "  ${OG}1] ${GN}Hacking${OG}                             3] ${GN}Apps and Downloads \\n${WT}\\n"
  printf "  ${OG}2] ${GN}Customize${OG}                           4] ${GN}Pwnagotchi${RED} \\n"
  printf "  ${OG}\\n"
  printf "  ${OG}98]${GN} Wifi is Broken! reset wifi" 
  printf "        ${OG}99]${GN} Display System Information                      \\n"
  printf " \\n"
  source ${scripts_dir}/support/support-Prompt_func.sh
  printf "     ---->  "
# Read user input and display the appropriate submenu
read -r choice
  printf "  ${CY}\\n"
#  printf "  ${CY}\\n"
if [[ ${choice} == 1 ]]; then  
    clear
    source ${scripts_dir}/support/support-Banner_func.sh
    printf "${CY}\\n\\n           You chose Hacking. ${RED}[!!!] ${CY}This menu is continually evolving.\\n"
    printf "\\n           ${OG}You can continue, but know that you may experience bugs or other weird shit.\\n"
    printf "\\n${GN}           You have been warned. ${RED}[!!!]\\n" 
    printf "\\n${CY}   ----    Press ${WT}any key ${CY}to continue.    ----    \\n"
      read -r -n1 -s -t 300
      clear
      #    Hacking_menu
    source ${scripts_dir}/menu-hacking.sh
elif [[ ${choice} == 2 ]]; then  
    clear
    source ${scripts_dir}/support/support-Banner_func.sh
    printf "${YW}\\n\\n           You chose Customize. ${RED}[!!!] ${CY}This menu is continually evolving.\\n"
    printf "\\n           ${OG}You can continue, but know that you may experience bugs or other weird shit.\\n"
    printf "\\n${GN}           You have been warned. ${RED}[!!!]\\n" 
    printf "\\n${CY}   ----    Press ${WT}any key ${CY}to continue.    ----    \\n"
      read -r -n1 -s -t 300
      clear
     source ${scripts_dir}/support/support-Banner_func.sh 
#    Customize_menu
     source ${scripts_dir}/menu-customize.sh
elif [[ ${choice} == 3 ]]; then  
    clear
    printf "${YW}\\n\\n           You chose Apps. ${RED}[!!!] ${CY}This menu is continually evolving.\\n"
    printf "\\n           ${OG}You can continue, but know that you may experience bugs or other weird shit.\\n"
    printf "\\n${GN}           You have been warned. ${RED}[!!!]\\n" 
    printf "\\n${CY}   ----    Press ${WT}any key ${CY}to continue.    ----    \\n"
      read -r -n1 -s -t 300
      clear
     source ${scripts_dir}/support/support-Banner_func.sh
      #    Download_menu
    source ${scripts_dir}/menu-apps.sh
elif [[ ${choice} == 4 ]]; then  
    printf "${YW}      You chose Pwnagotchi. In the Pwnagotchi module, you'll be able to backup and restore\\n"
    printf "${YW}      your Pwnagotchi. You could also setup a new device, upload your collected wifi hashes and\\" 
    printf "${YW}      handshakes or even install Pwnagotchi compatible software.\\n"
    printf "\\n${CY}   ----    Press ${WT}any key ${CY}to continue.    ----    \\n"
      read -r -n1 -s -t 300
    clear
#    Pwnagotchi_menu
    source ${scripts_dir}/menu-backup_pwn-script.sh
elif [[ ${choice} == 98 ]]; then  
    printf "${YW}      You chose Troubleshooting.  Wifi problems. Playing with these menus can occassionally\\n "
    printf "${YW}      leave your wifi adaptors and network services in varying states.\\n"
    printf "${YW}      This option will reset all nework adapters to managed mode and restart \\n"
    printf "${YW}      the NetworkManager and wpa_supplicant services."
    printf "\\n\\n      ${CY}Press ${WT}any ${CY}key to continue.${GN}"
      read -r -n1 -s -t 300
    #    Troubleshooting_menu
    source "${scripts_dir}/support/support-trap-wifi.sh"
    trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT
elif [[ ${choice} == 99 ]]; then  
    printf "${YW}      You chose System Information. \\n "
    clear
#    Sysinfo_menu
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-sysinfo.sh"
elif [[ ${choice} == 0 ]]; then  
#    Exit_menu
    clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    printf "${RED} [✘] Exit tool [✘]${NC} \\n"
    exit 1
else 
    printf "${RED}[!!!]${OG} Invalid Selection  ${RED}[!!!]"
fi
}
main
