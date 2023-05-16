#!/bin/bash
# Version: 0.0.3
set -e
function help {
  echo 
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -h, --help: Display this help information."
  echo "  -v, --version: Display the version information."
  echo
}

if [[ $1 == "-h" || $1 == "--help" ]]; then
  help
  exit 0
elif [[ $1 == "-v" || $1 == "--version" ]]; then
  echo "The script is version 0.0.2."
  exit 0
fi

scripts_dir=/opt/easy-linux
clear
source /opt/easy-linux/.envrc && source /opt/easy-linux/support/.whoami.sh 
trap "${scripts_dir}/support/trap-master.sh" EXIT
    
misc_func() {
  if [[ -f $HOME/.bashrc ]]; then
	echo "export TERM=xterm-color" >> ~/.bashrc
  fi
  if [[ -f $HOME/.zshrc ]]; then
  	echo "export TERM=xterm-color" >> ~/.zshrc
  fi
  if [[ -f $HOME/INSTALLv2.sh ]]; then
      rm -f $HOME/INSTALLv2.sh
  fi
  if [[ -f $HOME/Downloads/INSTALLv2.sh ]]; then
      rm -f $HOME/Downloads/INSTALLv2.sh
  fi
  if [[ -f ${scripts_dir}/INSTALLv2.sh ]]; then
      sudo rm ${scripts_dir}/INSTALLv2.sh
  fi
}

hack_func() {
    printf "\\n\\n      ${YW}You chose Hacking. ${RED}[!!!] ${CY}This menu is continually evolving. ${RED}[!!!]\\n"
    printf "\\n      ${OG}You can continue, but know that you may experience bugs or other weird shit.\\n"
    printf "\\n${GN}      You have been warned. You could consider this Beta software.\\n        " 
        read -n 1 -p "Do you want to continue? [Y/n] " choicehacking
        choicehacking=${choicehacking:-Y}
        if [[ "$choicehacking" =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
            clear
            source ${scripts_dir}/menu-hacking.sh
        elif [[ "$choicehacking" =~ ^[Nn]$ ]]; then
            printf "${RED} [✘] Exit tool [✘]${NC} \\n"
            exit 0
        else
            printf "      ${RED}Invalid Selection.\\n"
        fi
}
apps_func() {
    printf "${YW}\\n\\n      ${YW}You chose Apps. ${RED}[!!!] ${CY}This menu is continually evolving. ${RED}[!!!]\\n"
    printf "\\n      ${OG}You can continue, but know that you may experience bugs or other weird shit.\\n"
    printf "\\n${GN}      You have been warned. \\n        " 
    read -n 1 -p "Do you want to continue? [Y/n] " choiceapps
        choiceapps=${choiceapps:-Y}
        if [[ "$choiceapps" =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
            source ${scripts_dir}/menu-apps.sh
        elif [[ "$choiceapps" =~ ^[Nn]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
                exit 0
        else
            printf "      ${RED}Invalid Selection.\\n"
        fi  
}

cust_func() {

    printf "\\n\\n      ${YW}You chose Customize. ${RED}[!!!] ${CY}This menu is continually evolving. ${RED}[!!!] \\n"
    printf "\\n      ${OG}You can continue, but know that you may experience bugs or other weird shit.\\n"
    printf "\\n${GN}      You have been warned. You could consider this Beta software.\\n        " 
    read -n 1 -p "Do you want to continue? [Y/n] " choicecustom
        choicecustom=${choicecustom:-Y}
        if [[ "$choicecustom" =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
            clear
               source ${scripts_dir}/menu-customize.sh
        elif [[ "$choicecustom" =~ ^[Nn]$ ]]; then
               printf "${RED} [✘] Exit tool [✘]${NC} \\n"
               exit 0
        else
            printf "      ${RED}Invalid Selection.\\n"
        fi  
}
pwn_func() {
    printf "\\n\\n${YW}      You chose ${WT}Pwnagotchi${YW}. In the Pwnagotchi module, you'll be able to ${WT}backup and restore\\n"
    printf "${YW}      ${YW}your Pwnagotchi. You could also setup a new device, ${WT}upload your collected wifi\\n" 
    printf "${WT}      hashes ${YW}and handshakes or even ${WT}install Pwnagotchi compatible software.${CY}\\n        "
    read -n 1 -p "Do you want to continue? [Y/n] " choicepwn
        choicepwn=${choicepwn:-Y}
        if [[ "$choicepwn" =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
            source ${scripts_dir}/menu-pwn.sh
        elif [[ "$choicepwn" =~ ^[Nn]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
                exit 0
        else
            printf "      ${RED}Invalid Selection.\\n"
        fi
}
trouble_func() {
     printf "${YW}      You chose Troubleshooting.  This section is currently empty." 
         read -n 1 -p "Do you want to continue? [Y/n] " choicetrbl
         choicetrbl=${choicetrbl:-Y}
        if [[ "$choicetrbl" =~ ^[Yy]$ ]]; then
            printf "${CY}Continuing...\\n"
            source ${scripts_dir}/menu-troubleshooting.sh
        elif [[ "$choicetrbl" =~ ^[Nn]$ ]]; then
                printf "${RED} [✘] Exit tool [✘]${NC} \\n"
                exit 0
        else
            printf "$      {RED}Invalid Selection.\\n"
    #    Troubleshooting_menu
        fi


}
sysinfo_func() {
    source ${scripts_dir}/support/support-sysinfo.sh
}
# Function to handle menu selection
main_menu() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh" && sudo chown -vR 1000:0 /opt/easy-linux >/dev/null
    echo 
	printf "${OG}${BOLD}  $username                ${BOLD}${GN}Beesoc's Easy Linux Loader               $computername ${CY}\n"
	echo
	printf "  ${GN}Select an option:${CY}\n"
	echo
	printf "     ${WT}1)${CY}  Hacking${PL}: Install and Use Hacking Tools. No exp needed.${CY}\n"
	printf "     ${WT}2)${CY}  Apps${PL}: Install and Use a variety of awesome Linux tools.${CY}\n"
	printf "     ${WT}3)${CY}  Customize${PL}: Tweak various parts of your system, network or target.${CY}\n"
	printf "     ${WT}4)${CY}  Pwnagotchi${PL}: Backup/Restore, Connect to various Pwnagotchi features.${CY}\n"
	printf "     ${WT}5)${CY}  Troubleshooting${PL}: From network issues to time sync issues.${CY}\n"
	printf "     ${WT}6)${CY}  System Info${PL}: Various Sys Info about your Linux system.${CY}\n"
	printf "     ${WT}7)${CY}  Quit${PL}: Uhhh. It just quits.${CY}\n"
	echo
	printf "  ${WT}Selection: ${CY}\n"
	read -n 1 -r main_menu
	case "$main_menu" in
	1) hack_func ;;
	2) apps_func ;;
	3) cust_func ;;
	4) pwn_func ;;
	5) trouble_func ;;
	6) sysinfo_func ;;
	7) exit 0 ;;
	*) printf "${RED}Invalid selection.${CY}\n" ;;
	esac
}


# Main script logic
while true; do
	main_menu
	printf "${WT}Press any key to return to the main menu.${CY}\n"
	read -n 1 -r
done
