#!/bin/bash
# Version: 0.0.3
set -e
scripts_dir=/opt/easy-linux
trap "${scripts_dir}/support/trap-master.sh" EXIT

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
    echo "The script is version 0.0.3"
    exit 0
fi

source /opt/easy-linux/.envrc 
source /opt/easy-linux/support/.whoami.sh

check_for_updates() {
   cd /opt/easy-linux/support || exit
      local last_update_file=".last_update"
    # Check if the last update file exists
    if [[ -f "$last_update_file" ]]; then
        # Get the last update timestamp
        local last_update=$(cat "$last_update_file")

        # Calculate the time difference in seconds
        local current_time=$(date +%s)
        local time_diff=$((current_time - last_update))

        # Check if 24 hours have passed since the last update
        if [[ $time_diff -ge 86400 ]]; then
            printf "  ${OG}Checking for updates...\\n"

            # Run the update script
            ../update_scripts.sh

            # Update the last update timestamp
            echo "$current_time" > "$last_update_file"
        else
            printf "${OG}  Skipping update check. 24 hours have not passed since the last update.\\n"
        fi
    else
        printf "${GN}  First run. Checking for updates...\\n"

        # Run the update script
        /opt/easy-linux/update_scripts.sh

        # Create the last update file and set the timestamp
        sudo chown $USER:0 -vR /opt/easy-linux/support
        sudo echo "$(date +%s)" > "$last_update_file"
    fi
}


misc_func() {
    if [[ -f $HOME/.bashrc ]]; then
        if [[ $(cat $HOME/.bashrc | grep "xterm-color" -c) -eq 0 ]]; then
            echo "export TERM=xterm-color" >> ~/.bashrc
            echo "export COLORTERM=truecolor" >> ~/.bashrc
            echo "export COLORFGBG=15,0" >> ~/.bashrc
        fi
    fi
    if [[ -f $HOME/.zshrc ]]; then
        if [[ $(cat $HOME/.zshrc | grep "xterm-color" -c) -eq 0 ]]; then
            echo "export TERM=xterm-color" >> ~/.zshrc
            echo "export COLORTERM=truecolor" >> ~/.zshrc
            echo "export COLORFGBG=15,0" >> ~/.zshrc
        fi
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
        source ${scripts_dir}/install/menu-hacking.sh
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
        source ${scripts_dir}/install/menu-apps.sh
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
        source ${scripts_dir}/install/menu-customize.sh
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
        source ${scripts_dir}/install/menu-pwn.sh
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
        source ${scripts_dir}/install/menu-trouble.sh
    elif [[ "$choicetrbl" =~ ^[Nn]$ ]]; then
        printf "${RED} [✘] Exit tool [✘]${NC} \\n"
        exit 0
    else
        printf "$      {RED}Invalid Selection.\\n"
        #    Troubleshooting_menu
    fi
}

backup_func() {
                clear
       if [[ ${stand_install} -eq 0 ]]; then
   			printf "${OG}  Installing dependencies...\\n"
			source $scripts_dir/support/support-inst-standard.sh
       elif [[ ${stand_install} -eq 1 ]]; then
                                printf "${OG}  You have already installed Duplicati.\\n"
                                printf "Loading...Please wait"
                                sudo duplicati &
                                exit 0
       fi                     
                     
}


# Function to handle menu selection
main_menu() {
    clear
    source "${scripts_dir}/support/support-Banner_func.sh" && sudo chown -vR $USER:0 /opt/easy-linux >/dev/null
    echo
    printf "${BL}${BOLD}  $username                ${BOLD}${GN}Beesoc's Easy Linux Loader              ${BL} $computername ${CY}\n"
    echo
    printf "  ${GN}Select an option:${CY}\n"
    echo
    printf "     ${WT}1)${CY}  Hacking${PL}: Install and Use Hacking Tools. No exp needed.${CY}\n"
    printf "     ${WT}2)${CY}  Apps${PL}: Install and Use a variety of awesome Linux tools.${CY}\n"
    printf "     ${WT}3)${CY}  Customize${PL}: Tweak various parts of your system, network or target.${CY}\n"
    printf "     ${WT}4)${CY}  Pwnagotchi${PL}: Backup/Restore, Connect to various Pwnagotchi features.${CY}\n"
    printf "     ${WT}5)${CY}  Troubleshooting${PL}: From network issues to time sync issues.${CY}\n"
    printf "     ${WT}6)${CY}  Backup${PL}: Deduplicating and cloud enabled backups.${CY}\n"
    printf "     ${WT}7)${CY}  Quit${PL}: Uhhh. It just quits.${CY}\n"
    echo
    printf "  ${GN}Selection: ---->${OG} "
    read -n 1 -r main_menu
    case "$main_menu" in
        1) hack_func ;;
        2) apps_func ;;
        3) cust_func ;;
        4) pwn_func ;;
        5) trouble_func ;;
        6) backup_func ;;
        7) exit 0 ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
    esac
}

# Main script logic
main() {
# Call the update check function
check_for_updates

if [[ -f $HOME/INSTALLv2.sh ]]; then
        rm -f $HOME/INSTALLv2.sh
elif [[ -f $scripts_dir/INSTALLv2.sh ]]; then
	  rm $scripts_dir/INSTALLv2.sh
elif [[ -f $HOME/Downloads/INSTALLv2.sh ]]; then
        rm -f $HOME/Downloads/INSTALLv2.sh
elif [[ -e $HOME/version-easy-linux.sh ]]; then
    rm -rf $HOME/version-easy-linux.sh
fi

misc_func
while true; do
    main_menu
	    printf "${WT}Press any key to return to the main menu.${CY}\n"
	    read -n 1 -r
	done
}

main
