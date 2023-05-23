#!/bin/bash
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
source $scripts_dir/.envrc
source $scripts_dir/support/.whoami.sh
trap 'source "/opt/easy-linux/support/trap-master.sh"' EXIT
#shellcheck source=${scripts_dir}/.envrc
#shellcheck source=${scripts_dir}/support/support-Banner_func.sh
#shellcheck source=${scripts_dir}/support/support-Prompt_func.sh

backup_dir=/opt/backup

hosts_func() {
        printf "${GN}20]  ${CY}Edit your local ${WT}/etc/hosts ${CY}file to keep DNS happy and ${CY} \\n "
        printf "     refer to machines by hostname instead of IP.\\n"
        clear
        source "${scripts_dir}/support/support-Banner_func.sh"
        sudo apt update >/dev/null
        sudo apt install -y mdns nano >/dev/null
        sudo nano /etc/hosts
        sudo systemctl restart dnsmasq.service
        sudo systemctl restart NetworkManager.service
        sudo systemctl restart wpa_supplicant.service
}

ncdu_func() {
        printf "   ${OG}Searching for ${WT}ncdu${CY}. If found, I'll run ncdu. If not, I'll install it.\\n"
        sleep 1
        if [[ $(command -v ncdu >/dev/null 2>&1) ]]; then
                printf "${WT}ncdu ${CY}is installed\\n"
        else
                printf "${WT}ncdu ${CY}is not installed. Installing now.\\n"
                sleep 1
                printf "${GN}Please wait\\n"
                sleep 1
                printf "${GN}...\\n"
                sudo apt install -y ncdu >/dev/null
        fi
        sudo ncdu --color dark -ex --exclude-caches --exclude-kernfs --confirm-quit --exclude .cache --exclude os-iso --excude delme /
        return 0
}

timezone_func() {
        printf "${CY}  Fix Timezone and Time issues in Kali Linux. \\n "
        printf "TODO \\n"
}

locate_func() {
        clear
        source "${scripts_dir}/support/support-Banner_func.sh"
        printf "\\n      ${OG}[*] ${CY}pLocate: Find files and apps in an instant with pLocate.${GN} \\n\\n    "
        read -p "What do you want to search for? ----> " search
        clear
        printf " ${WT}"
        plocate $search
        printf "${CT}  Press ${WT}any ${CT}key to continue. \\n  ${OG}"
        read -r -n1 -s -t 120
}

perm_func() {
        printf "${OG}  3]  ${CY}Fix your perm - Permission probems in Linux can be a bitch.  Get help here. \\n "
        printf "${OG}  a]  ${CY}Fix permissions problems on ${WT}/opt/backup ${CY}and your ${WT}Home folder${CY} \\n  "
        printf "${OG}  b]  ${CY}Enter a custom folder to fix permissions on."
        source "${scripts_dir}/support/support-fix-my-perm.sh"
}

x11vnc_func() {
        sudo apt install -y x11vnc >/dev/null
        printf "${WT}  1]  ${CY}Start ${GN}x11vnc Server${CY} - Control PC remotely ${CY} \\n   "
        x11vnc -noxdamage -ncache 10 -ncache_cr -rfbauth ~/.vnc/passwd
}

main_menu_func() {
        source ${scripts_dir}/install/menu-master.sh
}

main_menu() {

clear
        source ${scripts_dir}/support/support-Banner_func.sh
        echo
        printf "${OG}          $USER               ${GN}Install or Run New Apps${OG}                $computername ${CY}\n"
        echo
        printf "  ${GN}Select an option:${CY}\n"
        echo
        printf "     ${WT}1)${CY}  All${PL}: \\n"
        printf "     ${WT}2)${CY}  Autojump${PL}: ${CY}\n"
        printf "     ${WT}3)${CY}  Docker Desktop${PL}: \n"
        printf "     ${WT}4)${CY}  Glances${PL}: \n"
        printf "     ${WT}5)${CY}  Hacking Apps${PL}: \n"
        printf "     ${WT}6)${CY}  Nano${PL}: \n"
        printf "     ${WT}7)${CY}  Oh My BASH! and Oh My ZSH!${PL}: ${CY}\n"
        printf "     ${WT}8)${CY}  SysInfo${PL}: \n"
        printf "     ${WT}9)${CY}  Standard/Favorites${PL}: \n"
        printf "    ${WT}10)${CY}  Webmin${PL}: \n"
        printf "    ${WT}11)${CY}  Return to Main Menu${PL}\n"
        printf "    ${WT}12)${CY}  [✘] Exit tool [✘]\n"
        echo
        printf "  ${GN}Selection: ${CY}\n"
          read -r main_menu_sel
        case "$main_menu_sel" in
#options=("All" "Autojump" "Docker Desktop"  "My Favs" "Glances" "Hacking Apps" "Nano" "Oh My..." "System Info" "Webmin"  "Main Menu" "Exit")

        1) all_func ;;
        2) autojump_func ;;
        3) docker_func ;;
        4) glances_func ;;
        5) hacking_func ;;
        6) nano_func ;;
        7) omymy_func ;;
        8) sysinfo_func ;;
        9) standard_func ;;
        10) webmin ;;
        11) mainmenu_func ''
        12) exit 0 ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
        esac
}

main() {
        # Main script logic

        while true; do
                main_menu
                printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
                read -n 1 -r
        done
}

main
source "${scripts_dir}/install/menu-master.sh"









install_apps_func() {
        clear
        options=("All" "Aircrack-NG" "Airgeddon" "Autojump" "Docker Desktop"  "My Favs" "Glances" "TheFatRat" "Hacking Tool" "Nano" "Oh My..." "System Info" "Webmin" "WiFite" "Main Menu" "Exit")
        source "$scripts_dir/support/support-Banner_func.sh"
        printf "\\n               ${OG}Select which app you would like to install or run.$GN\\n\\n"
        echo
        select option in "${options[@]}"; do
                case $option in
                "Airgeddon")
                        clear
                        source "$scripts_dir/support/support-Banner_func.sh"
                        printf "$GN\\n  You've selected ${WT}Airgeddon$CY.\\n    "
                        if [[ $airg_installed == 1 ]]; then
                                sudo airgeddon
                                airg_installed=1
                                sudo sed -i "s/airg_installed=.*/airg_installed=$airg_installed/g" "$scripts_dir/.envrc"
                        else
                                read -n 1 -p "Do you want to continue? [Y/n] " choiceairged
                                choiceairged=${choiceairged:-Y}
                        fi
                        if [[ $choiceairged =~ ^[Yy]$ ]]; then
                                printf "$GN  Continuing...\\n"
                        elif [[ $choiceairged =~ ^[Nn]$ ]]; then
                                printf "$RED  Cancelling. Returning to ${WT}Main Menu\\n"
                                source $scripts_dir/install/menu-master.sh
                        else
                                printf "$RED  Exiting.\\n"
                                exit 0
                        fi
                        source $scripts_dir/support/support-airgeddon.sh
                        ;;
                "Aircrack-NG")
                        if [[ $airc_installed == 1 ]]; then
                                printf "${GN}Aircrack-NG is already installed\\n"
                                sudo aircrack-ng --help
                                source ${scripts_dir}/install/menu-master.sh
                        else
                                printf "${YW}Aircrack-NG is not installed. Installing\\n"
                                source $scripts_dir/support/support-aircrack2.sh
                        fi
                        ;;
                "Autojump")
                        if [[ $autoj_install == 1 ]]; then
                                printf "${GN}Autojump is already installed\\n"
                                sudo autojump --help
                                source ${scripts_dir}/install/menu-master.sh
                        else
                                printf "${YW}Autojump is not installed. Installing\\n"
                                source $scripts_dir/support/support-autojump.sh
                        fi
                        ;;
                "Docker Desktop")
                        clear
                        if [[ $(command -v /opt/docker-desktop/bin/docker-desktop >/dev/null 2>&1) ]]; then
                                docker_installed=1
                                printf "${GN}Docker Desktop is already installed\\n"
                                sudo /opt/docker-desktop/bin/docker-desktop
                                sudo sed -i "s/docker_installed=.*/docker_installed=$docker_installed/g" "$scripts_dir/.envrc"
                        else
                                printf "${YW}Docker Desktop is not installed. Installing\\n"
                                source $scripts_dir/support/support-docker.sh
                        fi
                        ;;
                "Hacking Tool")
                        if [[ $hacktool-installed == 0 ]]; then
                                source $scripts_dir/support/support-hackingtool.sh
                        elif [[ $hacktool-installed == 1 ]]; then
                                sudo hackingtool
                                exit 0
                        fi
                        ;;
                "TheFatRat")
                        clear
                        source $scripts_dir/support/support-Banner_func.sh
                        if [[ $fatrat_installed == 1 ]]; then
                                printf "\\n${GN}The Fat Rat is already installed\\n"
                                sudo fatrat
                        else
                                source $scripts_dir/support/support-fatrat.sh
                        fi
                        ;;
                "My Favs")
                        if [[ $stand_install == 0 ]]; then
                                source $scripts_dir/support/support-inst-standard.sh
                        elif [[ $stand_install == 1 ]]; then
                                printf "$OG  You have already installed all of the standard tools.\\n"
                                exit 0
                        fi
                        ;;
                  "Glances")
                        if [[ $glances_install == 0 ]]; then
                                curl -L https://bit.ly/glances | /bin/bash
                                glances_install=1
                        elif [[ $glances_install == 1 ]]; then
                                printf "  Glances is installed."
                        fi
                        ;;
                "Main Menu")
                        printf "${OG}You selected ${WT}Main Menu\\n$CY"
                        source $scripts_dir/menu-master.sh
                        ;;
                "Nano")
                        nano_exe=$(which nano)
                        clear
                        if [[ $nano_installed == 1 ]]; then
                                sudo nano -ADEGHKMPSWZacdegmpqy%_ -T 4
                        elif [[ $nano_installed == 0 ]]; then
                                source $scripts_dir/support/support-nano.sh
                        fi
                        if [[ $nano_installed == 0 ]] && [[ -n $nano_exe ]]; then
                                nano_installed=1
                                sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" "$scripts_dir/.envrc"
                                sudo nano -ADEGHKMPSWZacdegmpqy%_ -T 4
                        fi
                        ;;
                "Oh My...")
                        clear
                        source "$scripts_dir/support/support-Banner_func.sh"
                        source "${scripts_dir}/support/support-ohmy.sh"
                        printf "\\n  ${CY}Installation complete.  Press ${WT}any ${CY}key to continue."
                        read -n 1 -t 300
                        source ${scripts_dir}/install/menu-master.sh
                        ;;
                "System Info")
                        clear
                        source "$scripts_dir/support/support-Banner_func.sh"
                        source "$scripts_dir/support/support-sysinfo.sh"
                        ;;
                "Webmin")
                        clear
                        source "$scripts_dir/support/support-Banner_func.sh"
                        read -p "Do you want to install/launch Webmin? [Y/n] " instweb
                        instweb=${instweb:-Y}
                        if [[ "$instweb" =~ ^[yY]$ ]]; then
                                if [[ $webmin_installed == 1 ]]; then
                                        printf "${OG}  Webmin already installed. Access via web browser at:\\n$WT "
                                        printf "https://localhost:10000\\n"
                                        printf "  ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
                                        read -n 1 -t 300
                                        source ${scripts_dir}/install/menu-master.sh
                                elif [[ ${webmin_installed} == 0 ]]; then
                                        source ${scripts_dir}/support/support-webmin.sh
                                        source ${scripts_dir}/install/menu-master.sh
                                else
                                        printf "  ${RED}Invalid Selection"
                                fi
                        elif [[ "$instweb" =~ ^[nN]$ ]]; then
                                printf "  ${WT}$USER ${RED}decided not to install Webmin. Exiting\\n\\n"
                                exit 0
                        else
                                printf "  ${RED} Invalid Selection"
                        fi
                        ;;
                "Wifite")
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
                        ;;
                "All")
                        printf "$PL       You chose ${WT}All.\\n\\n"
                        printf "$PL   Depending on speed of ${WT}PC and Internet$PL, this may take a while$YW\\n  "
                        read -n 1 -s -p "Are you sure you want to install All? [Y/n] " all_installed
                        all_installed=${all_installed:-Y}
                        if [[ $all_installed == "N" ]] || [[ $all_installed == "n" ]]; then
                                printf "$OG    $WT$USER ${OG}has selected to cancel $WT'Install All' ${OG}option".
                                exit 0
                        elif [[ $all_installed == "Y" ]] || [[ $all_installed == "y" ]]; then
                                for o in "${options[@]:0:12}"; do
                                        printf "${OG}Performing action for $WT$o$CY"
                                done
                        fi
                        break
                        ;;
                "Exit")
                        clear
                        printf "   ${WT}$USER ${RED}selected Exit$OG\\n"
                        exit 0
                        ;;
                *) printf "${RED}Invalid option entered.\\n ${GN}Please try again. Valid options are listed above. \n$CY" ;;
                esac
        done
}
personal_func() {
        if [[ $USER == "beesoc" ]] && [[ $computername == "updates" ]]; then
                source $scripts_dir/support/support-updates.sh
        else
                exit 0
        fi
}
 update_func() {
        printf "\\n      ${WT}[P]${GN}wnagotchi ${CY}or ${WT}[C]${GN}ontinue with ANY other Linux ${CY}distro? ----> "
        read -n 1 -r installchoice
        if [[ $installchoice == c ]] || [[ $installchoice == C ]]; then
                installchoice=${installchoice:-P}
                sudo apt update
                deps_install_func
                updates=$(sudo apt list --upgradable | wc -l)
                security_updates=$(sudo apt list --upgradable 2>/dev/null | grep -E '\[security|critical\]' | wc -l)
                printf "  ${CY}You have $updates updates available, of which $security_updates are security related or severe.\\n"
                printf "  ${CY}Please wait. This step may take ${WT}several minutes ${CY}depending on your internet speed!\\n"
                        printf "${RED}Security updates represent 20 percent or more of available updates.  Performing upgrade. "
                        sudo apt upgrade -y
                        printf "\\n${GN}Security updates represent 20 percent or less of available updates.  Perform upgrade? [Y/n] "
                        read -r perfupgrade
                        perfupgrade=${perfupgrade:-Y}
                        if [[ $perfupgrade == n ]] || [[ $perfupgrade == N ]]; then
                                printf "  ${RED}Your system is at severe risk. Updates should be installed soon."
                        elif [[ $perfupgrade == y ]] || [[ $perfupgrade == Y ]]; then
                                sudo apt upgrade -y
                        fi
                fi

         ending_func
 }        

deps_install_func() {
        packages=("bc" "acpi" "ccze" "colorized-logs" "xrootconsole" "x11-utils" "iw" "gawk" "autoconf" "automake" "libtool" "pkg-config" "rfkill" "libpcap-dev" "lsusb" "wget" "ethtool" "systemd" "grep" "uname" "sed" "hostapd" "wpasupplicant" "screen" "groff" "grc")
        for package in "${packages[@]}"; do
                if dpkg -s "$package" >/dev/null 2>&1; then
                        echo "$package is already installed"
                else
                        echo "Installing $package"
                        sudo apt-get --ignore-missing --show-progress install -y "$package"
                fi
                menu_apps_deps=1
                sudo sed -i "s/menu-apps-deps=.*/menu-apps-deps=$menu-apps-deps/g" "$scripts_dir/.envrc"
                install_apps_func
        done
}

ending_func() {                
                if [[ $installchoice == p ]] || [[ $installchoice == P ]]; then

                deps_install_func
        fi
        clear
        source $scripts_dir/support/support-Banner_func.sh
        read -n 1 -p "Press M to return to main menu or X to Exit. [M/x]" menuchoice
        menuchoice=${menuchoice:-M}
        if [[ $menuchoice == m ]] || [[ $menuchoice == M ]]; then
                source $scripts_dir/install/menu-master.sh
        elif [[ $menuchoice == x || $menuchoice == X ]]; then
                echo
                exit 0
        else
                echo "Invalid Selection"
        fi
}


main() {
        clear
        #hazinternet=$(source ${scripts_dir}/support/support-ican-haz-internet.sh) && 
        source "$scripts_dir/support/support-Banner_func.sh"
        printf "\\n              ${CY}First, we will ${WT}update/upgrade ${CY}all packages.\\n"
        printf "\\n                    ${RED}[!!!] ${YW}IMPORTANT CHOICE ${RED}[!!!]\\n "
        printf "\\n             ${CY}Enter the ${WT}C ${CY}key to continue for ${GN}ANYTHING EXCEPT$CY a Pwnagotchi.\\n"
        printf "     ${GN}---->   ${CY}If you're using a Pwnagotchi, enter ${WT}P ${CY}to continue.${NC}\\n${CY}"
        #if [[ $hazinternet = 0 ]]; then
            # printf "\\n          ${GN}Your PC is showing that you ${WT}ARE ${GN}connected to the internet. \\n"
        #elif [[ $hazinternet = 1 ]]; then
            # printf "\\n         ${OG}Your PC is showing that you ${WT}ARE NOT ${OG}connected to the internet. \\n"
        #fi
        printf "\\n         ${RED}[!!!] ${YW}DONT UPDATE/UPGRADE A PWNAGOTCHI, ENTER P ${RED}[!!!]$NC\\n"
        update_func
        
}


main
