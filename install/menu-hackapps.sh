#!/bin/bash
# Install/Run hacking apps
scripts_dir=/opt/easy-linux

#shellcheck source=${scripts_dir}/.envrc
#shellcheck source=${scripts_dir}/support/support-Banner_func.sh
#shellcheck source=${scripts_dir}/support/support-Prompt_func.sh
set -e
source ${scripts_dir}/.envrc
trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT

# Version: 0.0.2

wifite_func() {
               clear
                        source "$scripts_dir/support/support-Banner_func.sh"
                        if [[ $wifite_installed == 1 ]]; then
                                printf "\\n${GN}Wifite is already installed\\n"
                                sudo wifite
                        elif [[ $wifite_installed == 0 ]]; then
                                printf "    \\n${YW}Wifite is not installed\\n"
                                source "$scripts_dir/support/support-wifite.sh"
                                wifite_installed=1
                        fi
       
}

hackingtool_func() {
           if [[ $hacktool-installed == 0 ]]; then
                                source $scripts_dir/support/support-hackingtool.sh
                        elif [[ $hacktool-installed == 1 ]]; then
                                sudo hackingtool 
                         fi
      
}

fatrat_func() {
                      clear
                        source $scripts_dir/support/support-Banner_func.sh
                        if [[ $fatrat_installed == 1 ]]; then
                                printf "\\n${GN}The Fat Rat is already installed\\n"
                                sudo fatrat
                        else
                                source $scripts_dir/support/support-fatrat.sh
                        fi

}

airgeddon_func() {
     clear
  source "$scripts_dir/support/support-Banner_func.sh"
  printf "$GN\\n  You've selected ${WT}Airgeddon$CY.\\n    "
  if [[ $airg_installed == 1 ]]; then
       sudo airgeddon
       sudo sed -i "s/airg_installed=.*/airg_installed=$airg_installed/g" "$scripts_dir/.envrc"
  else
       read -n 1 -p "Do you want to continue? [Y/n] " choiceairged
       choiceairged=${choiceairged:-Y}
  
        if [[ $choiceairged =~ ^[Yy]$ ]]; then
                                printf "\\n$GN  Continuing...\\n"
                     source $scripts_dir/support/support-airgeddon.sh
        elif [[ $choiceairged =~ ^[Nn]$ ]]; then
                                printf "$RED  Cancelling. Returning to ${WT}Main Menu\\n"
                                source $scripts_dir/install/menu-master.sh
        else
                                printf "$RED  Exiting.\\n"
                                exit 0
        fi
  fi
}

aircrack_func() {
         if [[ $airc_installed == 1 ]]; then
                                printf "${GN}Aircrack-NG is already installed\\n"
                                sudo aircrack-ng --help
                                source ${scripts_dir}/install/menu-master.sh
         else
                                printf "${YW}Aircrack-NG is not installed. Installing\\n"
                                source $scripts_dir/support/support-aircrack2.sh
         fi
  
}

main_menu_func() {
        source ${scripts_dir}/install/menu-master.sh
}

main_menu() {
        clear
        source ${scripts_dir}/support/support-Banner_func.sh
        echo
        printf "${OG}        $USER            ${GN}Install and Run Hacking Apps${OG}             $computername ${CY}\n"
        echo
        printf "  ${GN}Select an option:${CY}\n"
        echo
        printf "    ${WT}1)${CY}  Aircrack-NG${PL}: Basically required for hacking. Used in background of MANY apps.\n"
        printf "    ${WT}2)${CY}  Airgeddon${PL}: All in 1 hacker. Awesome and easy.\n"
        printf "    ${WT}3)${CY}  The Fat Rat${PL}: Malware creator that bypasses most AV.\n"
        printf "    ${WT}4)${CY}  HackingTool${PL}: Swiss army knife hacker. Contains MANY other tools.\n"
        printf "    ${WT}5)${CY}  WiFite 2${PL}: All in 1 hacker. Awesome and easy.\n"
        printf "    ${WT}6)${CY}  Return to Main Menu${PL}: Return to Easy Linux Main Menu\n"
        printf "    ${WT}7)${CY}  [✘] Exit tool [✘]${PL}: Uh, it just exits.\n"
        echo
        printf "  ${GN}Selection: ---->${OG}  "
    read -n 1 -r main_menu_sel
        case "$main_menu_sel" in'\e[1;36m'
        1) aircrack_func ;;
        2) airgeddon_func ;;
        3) fatrat_func ;;
        4) hackingtool_func ;;
        5) wifite_func ;;
        6) main_menu_func ;;
        7) exit 0 ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
        esac
}

main() {
        # Main script logic
        clear
        source "$scripts_dir/support/support-Banner_func.sh"
        printf "\\n              ${CY}First, we will ${WT}update/upgrade ${CY}all packages.\\n"
        printf "\\n                    ${RED}[!?!] ${YW}IMPORTANT CHOICE ${RED}[!?!]\\n "
        printf "\\n             ${CY}Enter the ${WT}C ${CY}key to continue for ${GN}ANYTHING EXCEPT$CY a Pwnagotchi.\\n"
        printf "     ${GN}---->   ${CY}If you're using a Pwnagotchi, enter ${WT}P ${CY}to continue.${NC}\\n${CY}"
        echo
        printf "\\n         ${RED}[!!!] ${YW}DONT UPDATE/UPGRADE A PWNAGOTCHI, ENTER P ${RED}[!!!]$NC\\n"
        printf "\\n      ${WT}[P]${GN}wnagotchi ${CY}or ${WT}[C]${GN}ontinue with ANY other Linux ${CY}distro? ----> "
        read -n 1 -r installchoice
        installchoice=${installchoice:-P}
        if [[ $installchoice == c ]] || [[ $installchoice == C ]]; then
                sudo apt update
                sudo apt upgrade
        elif [[ $installchoice == p ]] || [[ $installchoice == P ]]; then
            echo
        else
            printf "${RED}  Invalid Selection.  Please select C or P only.${NC}\\n"
        fi
        
        while true; do
                main_menu
                printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
                read -n 1 -r
        done
}

main
