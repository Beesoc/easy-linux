#!/bin/bash
# Version: 0.0.3
set -e
scripts_dir=/opt/easy-linux
source $scripts_dir/.envrc
source $scripts_dir/support/.whoami.sh
trap "/opt/easy-linux/support/trap-master.sh" EXIT
#shellcheck source=${scripts_dir}/.envrc
#shellcheck source=${scripts_dir}/support/support-Banner_func.sh
#shellcheck source=${scripts_dir}/support/support-Prompt_func.sh

webmin() {
                        read -p "Do you want to install/launch Webmin? [Y/n] " instweb
                        instweb=${instweb:-Y}
                        if [[ "$instweb" =~ ^[yY]$ ]]; then
                                if [[ $webmin_installed == 1 ]]; then
                                        printf "${OG}  Webmin already installed. Access via web browser at:\\n$WT "
                                        printf "https://localhost:10000\\n"
                                        printf "  ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
                                        read -n 1 -t 300
                                elif [[ ${webmin_installed} == 0 ]]; then
                                        source ${scripts_dir}/support/support-webmin.sh
                                else 
                                     printf "${RED}Invalid Selection. Options are Y or N only."
                                fi
                        elif [[ "$instweb" =~ ^[nN]$ ]]; then
                                printf "  ${WT}$USER ${RED}decided not to install Webmin. Exiting\\n\\n"
                                exit 0
                        fi

}

standard_func() {
                        if [[ ${stand_install} -eq 0 ]]; then
                                source $scripts_dir/support/support-inst-standard.sh
                        elif [[ ${stand_install} -eq 1 ]]; then
                                printf "${OG}  You have already installed all of the standard tools.\\n"
                                return 0
                        fi
}

duplicati_func() {
                clear
       if [[ ${stand_install} -eq 0 ]]; then
   			printf "${OG}  Installing dependencies...\\n"
			source $scripts_dir/support/support-inst-standard.sh
       elif [[ ${stand_install} -eq 1 ]]; then
                                printf "${OG}  You have already installed Duplicati.\\n"
                                return 0
       fi                     
                     
}

ohmy_func() {
         if [[ -d $HOME/.oh-my-bash || -d $HOME/.oh-my-zsh ]]; then
               if [[ -d $HOME/.oh-my-bash ]]; then
                  printf "Oh My BASH! is already installed."
               fi
               if [[ -d $HOME/.oh-my-zsh ]]; then
                  printf "Oh My ZSH! is already installed."
               fi
        read -n 1 -p "Do you want to install/reinstall either Oh My BASH or Oh My ZSH? [Y/n] " reinohmy
        reinohmy=${reinohmy:-Y}
              if [[ "$reinohmy" =~ ^[nN]$ ]]; then
                   return 0
              elif [[ "$reinohmy" =~ ^[yY]$ ]]; then   
                   printf "  ${CY}Install/Reinstall requested. Loading..."
              fi
         fi
                        clear
                        source "$scripts_dir/support/support-Banner_func.sh"
                        source "${scripts_dir}/support/support-ohmy.sh"
                        printf "\\n  ${CY}Installation complete.  Press ${WT}any ${CY}key to continue."
                        read -n 1 -t 300

}

nano_func() {
                        nano_exe=$(which nano)
                        if [[ $nano_installed == 1 ]]; then
                                sudo nano -ADEGHKMPSWZacdegmpqy%_ -T 4
                        elif [[ $nano_installed == 0 ]]; then
                                source $scripts_dir/support/support-nano.sh
                        fi
                        if [[ $nano_installed == 0 ]] && command -v $nano_exe; then
                                nano_installed=1
                                sudo sed -i "s/nano_installed=.*/nano_installed=$nano_installed/g" "$scripts_dir/.envrc"
                                sudo nano -ADEGHKMPSWZacdegmpqy%_ -T 4
                        fi

}

ncdu_func() {
  if [ $ncdu_installed = 1 ] && command -v ncdu >/dev/null; then
    ncdu --color dark -x --exclude-caches --exclude-kernfs --exclude .local --confirm-quit --exclude .cache /
  else
    sudo apt install -y ncdu
    ncdu_installed=1
    sudo sed -i "s/ncdu_installed=.*/ncdu_installed=$ncdu_installed/g" "$scripts_dir/.envrc"
  fi
}

hacking_func() {
    source ${scripts_dir}/install/menu-hacking.sh
}

glances_func() {
       if [[ $glances_install == 1 ]]; then
                                printf "  Glances is installed."
                                sudo glances
       elif [[ $glances_install == 0 ]]; then
            printf "  ${CY}Glances can be installed via an automated script or from source.\\n"
            printf "  We should try the [a]utomated installer first, then via [s]ource if that fails.\\n" 

                  read -n 1 -p "[a]utomated installer or [s]ource install? [A/s] " aglan
                  aglan=${aglan:-A}
                  if [[ "$aglan" =~ ^[aA]$ ]]; then
                      curl -L https://bit.ly/glances | /bin/bash
                      glances_install=1
                      sudo sed -i "s/glances_install=.*/glances_install=$glances_install/g" "$scripts_dir/.envrc"
                  elif [[ "$aglan" =~ ^[sS]$ ]]; then
                      printf "TODO: Sorry, I haven't done this yet.\\n"
                  else
                      printf "${RED}  Invalid Selection. Options are A or S only.\\n"
                  fi
       fi

}

docker_func() {
                   clear
                        if [ -e /opt/docker-desktop/bin/docker-desktop || command -v docker >/dev/null ]; then
                                docker_installed=1
                                printf "${GN}Docker Desktop is already installed\\n"
                                sudo /opt/docker-desktop/bin/docker-desktop
                                sudo sed -i "s/docker_installed=.*/docker_installed=$docker_installed/g" "$scripts_dir/.envrc"
                        else
                                printf "${YW}Docker Desktop is not installed. Installing\\n"
                                source $scripts_dir/support/support-docker.sh
                        fi
      
}

personal_func() {
                source $scripts_dir/support/support-updates.sh
}

autojump_func() {
                        if [[ $autoj_install == 1 ]]; then
                                printf "${GN}Autojump is already installed\\n"
                                sudo autojump --help
                        else
                                printf "${YW}Autojump is not installed. Installing\\n"
                                source $scripts_dir/support/support-autojump.sh
                        fi
 
}

all_func() {
        printf "  ${OG}This functionality is not working yet.\\n"
        return 0
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
        printf "     ${WT}1)${CY}  All${PL}: TODO: NOT WORKING YET\\n"
        printf "     ${WT}2)${CY}  Autojump${PL}: Terminal addon; improve efficiency & quickly jump around machine${CY}\n"
        printf "     ${WT}3)${CY}  Docker Desktop${PL}: Amazing Sauce. Run apps in containers and forget about dependencies.\n"
        printf "     ${WT}4)${CY}  Glances${PL}: Show detailed sysinfo on the terminal or access it via web browser.\n"
        printf "     ${WT}5)${CY}  Hacking Apps${PL}: Launch the Hacking Menu. For uhhh, hacking.\n"
        printf "     ${WT}6)${CY}  Nano${PL}: Small, efficient terminal based text editor.\n"
        printf "     ${WT}7)${CY}  ncdu${PL}: Manage Disk space with terminal based super fast file manager.\n"
        printf "     ${WT}8)${CY}  Oh My BASH! and Oh My ZSH!${PL}: Increase productivity and make your terminal sexy.${CY}\n"
        printf "     ${WT}9)${CY}  Duplicati${PL}: Data deduplicating, encrypted online backups! \n"
        printf "    ${WT}10)${CY}  Standard/Favorites${PL}: Some favorites/required packages from Easy-Linux.\n"
        printf "    ${WT}11)${CY}  Webmin${PL}: Manage almost every aspect of your system via web browser.\n"
        printf "    ${WT}12)${CY}  Return to Main Menu${PL}: Return to the Easy Linux Main Menu\n"
        printf "    ${WT}13)${CY}  [✘] Exit tool [✘]${PL}: Uhh, it exits.\n"
        echo
        printf "  ${GN}Selection: ---->${OG} "
          read -r main_menu
          case "$main_menu" in
        1) all_func ;;
        2) autojump_func ;;
        3) docker_func ;;
        4) glances_func ;;
        5) hacking_func ;;
        6) nano_func ;;
        7) ncdu_func ;;
        8) ohmy_func ;;
        9) duplicati_func ;;
        10) standard_func ;;
        11) webmin_func ;;
        12) main_menu_func ;;
        13) exit 0 ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
        esac
}

deps_install_func() {
        packages=("bc" "acpi" "ccze" "colorized-logs" "xrootconsole" "x11-utils" "iw" "gawk" "autoconf" "automake" "libtool" "pkg-config" "rfkill" "libpcap-dev" "wget" "ethtool" "systemd" "grep" "sed" "hostapd" "wpasupplicant" "screen" "groff" "grc")
        for package in "${packages[@]}"; do
                if dpkg -s "${package[*]}" >/dev/null 2>&1; then
                        echo "${package[*]} is already installed\\n"
                else
                        echo "Installing ${package[*]}\n"
                        sudo apt-get --ignore-missing --show-progress install -y "${package[*]}"
                fi
        done
         menu_apps_deps=1
         sudo sed -i "s/menu_apps_deps=.*/menu_apps_deps=$menu_apps_deps/g" "$scripts_dir/.envrc"
}

main() {
        # Main script logic
        pc="$(cat /etc/hostname)"

        if [[ $menu_apps_deps == 0 ]]; then
           deps_install_func
        fi

        while true; do
                main_menu
                printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
                read -n 1 -r
        done

        if [[ "$USER" == "$cwb_username" && "$pc" == "$cwb_computername" ]]; then
             personal_func
        fi
}

main
