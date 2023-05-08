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

# Define usage function
function usage {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --help         Display this help message"
  echo "                                          "
  echo "                                          "
}

# Parse command line arguments with getopts
while getopts "h:" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument" >&2
      usage
      exit 1
      ;;
  esac
done

determine_mac_func() {

if [ $wlan_count == 1 ]; then
   wlan0_mac=$(ip address show wlan0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)
   echo "export wlan0_mac=$(ip address show wlan0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)" >> ${scripts_dir}/.envrc
elif [ $wlan_count == 2 ]; then
   wlan0_mac=$(ip address show wlan0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)
   echo "export wlan0_mac=$(ip address show wlan0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)" >> ${scripts_dir}/.envrc
   wlan1_mac=$(ip address show wlan1 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)
   echo "export wlan1_mac=$(ip address show wlan1 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)" >> ${scripts_dir}/.envrc
fi

if [ $usb_count == 1 ]; then
   usb0_mac=$(ip address show usb0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)
   echo "export usb0_mac=$(ip address show usb0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)" >> ${scripts_dir}/.envrc
elif [ $usb_count == 2 ]; then
   usb0_mac=$(ip address show usb0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)
   echo "export usb0_mac=$(ip address show usb0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)" >> ${scripts_dir}/.envrc
   usb1_mac=$(ip address show usb1 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)
   echo "export usb1_mac=$(ip address show usb1 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)" >> ${scripts_dir}/.envrc
fi

}

main() {
# Display the main menu
determine_mac_func
  clear
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "                  ${OG}[???]${CY} Please select an option: ${OG}[???]${CY}        ${RED}[✘] Exit tool [✘] \\n \\n"
  printf "  ${OG}1] ${GN}Hacking${OG}                             3] ${GN}Apps \\n${WT}\\n"
  printf "  ${OG}2] ${GN}Customize${OG}                           4] ${GN}Pwnagotchi${RED}\\n"
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
        read -n 1 -p "Do you want to continue? [Y/n] " choicehacking
        choicehacking=${choicehacking:-Y}
        if [[ $choicehacking =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
            clear
      #    Hacking_menu
               source ${scripts_dir}/menu-hacking.sh
        elif [[ $choicehacking =~ ^[Nn]$ ]]; then
               printf "${RED} [✘] Exit tool [✘]${NC} \\n"
            exit
        else
            printf "${RED}Invalid Selection.\\n"
        fi

elif [[ ${choice} == 2 ]]; then  
    clear
    source ${scripts_dir}/support/support-Banner_func.sh
    printf "${YW}\\n\\n           You chose Customize. ${RED}[!!!] ${CY}This menu is continually evolving.\\n"
    printf "\\n           ${OG}You can continue, but know that you may experience bugs or other weird shit.\\n"
    printf "\\n${GN}           You have been warned. ${RED}[!!!]\\n" 
    read -n 1 -p "Do you want to continue? [Y/n] " choicecustom
        choicecustom=${choicecustom:-Y}
        if [[ $choicecustom =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
            clear
      #    customize_menu
               source ${scripts_dir}/menu-customize.sh
        elif [[ $choicecustom =~ ^[Nn]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
            exit
        else
            printf "${RED}Invalid Selection.\\n"
        fi  

elif [[ ${choice} == 3 ]]; then  
    clear
    printf "${YW}\\n\\n           You chose Apps. ${RED}[!!!] ${CY}This menu is continually evolving.\\n"
    printf "\\n           ${OG}You can continue, but know that you may experience bugs or other weird shit.\\n"
    printf "\\n${GN}           You have been warned. ${RED}[!!!]\\n" 
    read -n 1 -p "Do you want to continue? [Y/n] " choiceapps
        choiceapps=${choiceapps:-Y}
        if [[ $choiceapps =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
            clear
      #    customize_menu
               source ${scripts_dir}/menu-apps.sh
        elif [[ $choiceapps =~ ^[Nn]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
            exit
        else
            printf "${RED}Invalid Selection.\\n"
        fi  
      #    Apps_menu

elif [[ ${choice} == 4 ]]; then  
    printf "${YW}      You chose Pwnagotchi. In the Pwnagotchi module, you'll be able to backup and restore\\n"
    printf "${YW}      your Pwnagotchi. You could also setup a new device, upload your collected wifi hashes and\\" 
    printf "${YW}      handshakes or even install Pwnagotchi compatible software.\\n"
    read -n 1 -p "Do you want to continue? [Y/n] " choicepwn
        choicepwn=${choicepwn:-Y}
        if [[ $choicepwn =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
      #    pwnagotchi_menu
               source ${scripts_dir}/menu-backup_pwn-script.sh
        elif [[ $choicepwn =~ ^[Nn]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
            exit
        else
            printf "${RED}Invalid Selection.\\n"
        fi
        
elif [[ ${choice} == 98 ]]; then  
    printf "${YW}      You chose Troubleshooting.  Wifi problems. Playing with these menus can occassionally\\n "
    printf "${YW}      leave your wifi adaptors and network services in varying states.\\n"
    printf "${YW}      This option will reset all nework adapters to managed mode and restart \\n"
    printf "${YW}      the NetworkManager and wpa_supplicant services."
    read -n 1 -p "Do you want to continue? [Y/n] " choicetrbl
        choicetrbl=${choicetrbl:-Y}
        if [[ $choicetrbl =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
               source ${scripts_dir}/menu-troubleshooting.sh
        elif [[ $choicetrbl =~ ^[Nn]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
            exit
        else
            printf "${RED}Invalid Selection.\\n"
    #    Troubleshooting_menu
        fi

    trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT

elif [[ ${choice} == 99 ]]; then  
    printf "${YW}      You chose System Information. \\n "
    read -n 1 -p "Do you want to continue? [Y/n] " choiceinfo
        choiceinfo=${choiceinfo:-Y}
        if [[ $choiceinfo =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
               source ${scripts_dir}/support/support-sysinfo.sh
        elif [[ $choiceinfo =~ ^[Nn]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
            exit
        else
            printf "${RED}Invalid Selection.\\n"
    #    Troubleshooting_menu
        fi
elif [[ ${choice} == "x" ]] || [[ ${choice} == "X" ]] || [[ ${choice} == "0" ]]; then  
#    Exit_menu
    read -n 1 -p "Do you really want to exit? [y/N] " choiceexit
        choiceexit=${choiceexit:-N}
        if [[ $choiceexit =~ ^[Nn]$ ]]; then
                return
        elif [[ $choiceexit =~ ^[Yy]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
            exit 0
        else
            printf "${RED}Invalid Selection.\\n"
        fi 
else 
    printf "${RED}[!!!]${OG} Invalid Selection  ${RED}[!!!]"
fi
}
main
