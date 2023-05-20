#!/bin/bash
#
# Version: 0.0.2
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc

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

set -e

trap "bash ${scripts_dir}/support/support-trap-wifi.sh" EXIT
clear

if [[ $(command -v direnv >dev/null) ]]; then
        cd ${scripts_dir}
        direnv allow
	sudo direnv allow
fi

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

sysinfo_func(){
source ${scripts_dir}/support/support-sysinfo.sh
}

airg_func() {
    source ${scripts_dir}/support/support-airgeddon.sh
}

wifite_func() {
    source ${scripts_dir}/support/support-wifite.sh
}

cap_hash_func() {
   source ${scripts_dir}/support/support-hcxdump.sh
}

up_hash_func() {
    source ${scripts_dir}/menu-upload-hashes.sh
}

hacktool_func() {
    source ${scripts_dir}/support/support-hackingtool.sh
}

wordlist_func() {
    printf "${GN}      You chose Wordlists.  \\n  ${CY}This module will ${WT}merge, sort ${CY}and ${WT}delete duplicates ${CY}from your wordlists.${OG}\\n  "
    read -n 1 -p "Do you want to continue? [Y/n] " choicetrbl
    choicetrbl=${choicetrbl:-Y}
    if [[ "$choicetrbl" =~ ^[Yy]$ ]]; then
        printf "${CY}Continuing...\\n"
        source ${scripts_dir}/support/support-makeWordlist.sh
    elif [[ "$choicetrbl" =~ ^[Nn]$ ]]; then
        printf "${RED} [✘] Exit tool [✘]${NC} \\n"
        exit 0
    else
        printf "$      {RED}Invalid Selection.\\n"
        #    Troubleshooting_menu
    fi
}

monit_func() {
    source ${scripts_dir}/support/support-monitor.sh
}

# Function to handle menu selection
main_menu() {
    misc_func
    sudo chown -vR $USER:0 /opt/easy-linux 2>/dev/null
    clear
source "${scripts_dir}/support/support-Banner_func.sh"
    echo
    printf "${BL}${BOLD}  $USER                   ${BOLD}${GN}Easy Linux Hacking Center                ${BL} $computername ${CY}\n"
    echo
    printf "  ${GN}Select an option:${CY}\n"
    echo
    printf "     ${WT}1)${CY}  Monitor Mode${PL}: Toggle ${WT}Monitor Mode"${PL}" on/off.${CY}\n"
    printf "     ${WT}2)${CY}  Wordlists:${PL}: ${WT}Merge, Sort ${PL}and ${WT}Delete ${PL}duplicates ${CY}\n"
    printf "     ${WT}3)${CY}  Upload Hashes${PL}: ${WT}Upload Hashes ${PL}and ${WT}Handshakes ${PL}to cracking sites ${CY}\n"
    printf "     ${WT}4)${CY}  Capture Hashes${PL}: ${WT}Capture ${PL}and"${WT}" save hashes ${PL}and Handshakes ${CY}\n"
    printf "     ${WT}5)${CY}  WiFite 2${PL}: ${WT}All in 1 ${PL}Hacking Tool ${CY}\n"
    printf "     ${WT}6)${CY}  Airgeddon${PL}: ${WT}All in 1 ${PL}Hacking Tool ${CY}\n"

    printf "     ${WT}7)${CY}  HackingTool${PL}: ${WT}Swiss Army knife ${PL}hacking tool. MANY tools in 1${CY}\n"
    printf "     ${WT}8)${CY}  System Info${PL}: Various ${WT}Sys Info ${PL}about your Linux system.${CY}\n"
    printf "     ${WT}9)${CY}  Quit${PL}: Uhhh. It just ${WT}quits${PL}.${CY}\n"
    echo
    printf "  ${WT}Selection: ${GN}----> "
    read -n 1 -r main_menu
    case "$main_menu" in
        1) monit_func ;;
        2) wordlist_func ;;
        3) up_hash_func ;;
        4) cap_hash_func ;;
        5) wifite_func ;;
        6) airg_func ;;
        7) hacktool_func ;;
        8) sysinfo_func ;;
        9) exit 0 ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
    esac
}

# Main script logic
while true; do
    main_menu
    printf "${WT}Press any key to return to the main menu.${CY}\n"
    read -n 1 -r
done

