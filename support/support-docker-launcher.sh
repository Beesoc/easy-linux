#!/bin/bash
scripts_dir=/opt/easy-linux
docker_src=/opt/easy-linux/support/misc/docker

######################################################    
#  User Options can be set here                      #
#                                                    #
network=lsio          # docker network used          #
appd_dir=/opt/appdata # base install path            #
PUID=$(id -u)         # your PID; get by running id  #
PGID=$(id -g)         # your GID; get by running id  #
TZ=America/Chicago    # change your Timezone         #
######################################################

set -e

source "${scripts_dir}/.envrc"
#trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT

# Version: 0.0.3

emulatorjs_func() {
  printf "${OG}Do you want to launch the ${WT}[b]${OG}ackend config or the ${WT}[f]${OG}rontend to play? [b/F] "
  read -n 1 -r choice
  choice=${choice:-F}
  if [[ "${choice}" =~ ^[fF]$ ]]; then
  	xdg-open http://localhost:83
  elif [[ "${choice}" =~ ^[bB]$ ]]; then
  	xdg-open http://localhost:3003
  else
      printf "${RED} Invalid Selection.  Choices are F or B.\\n"
  fi
}

docker_up_func() {
        if [[ $(docker ps -a | grep "${container}" -c) -eq 1 ]] && [[ $(docker ps | grep "${container}" -c) -eq 0 ]]; then
                printf "  "${container}" is stopped. Restarting "${container}".\\n "
                docker-compose down
                docker rm "${container}"
        elif [[ $(docker ps -a | grep "${container}" -c) -eq 0 ]] && [[ $(docker ps | grep "${container}" -c) -eq 1 ]]; then
                printf "  "${container}" is already running.\\n "   
        else
                printf "  Starting requested container, "${container}".\\n"
        fi
        docker-compose up -d
        docker network connect ${network} ${container} 
        docker logs "${container}"    
        if [[ "${container}" == "emulatorjs" ]]; then emulatorjs_func; fi
}

exists_func() {
        if [[ -d "${appd_dir}" ]]; then
                if [[ -d "${appd_dir}"/"${container}" ]]; then
                        cd "${docker_src}"/"${container}" || exit
                else
                        sudo mkdir "${appd_dir}"/"${container}"
                        cd "${docker_src}"/"${container}" || exit
                fi
        else
                sudo mkdir "${appd_dir}"
                sudo mkdir "${appd_dir}"/"${container}"
                cd "${docker_src}"/"${container}" || exit
        fi
        docker_up_func
}

network_func() {
        if [[ $(docker network ls | grep "lsio" -c) -eq 0 ]]; then
                docker network create ${network}
        fi
}

hacktools_menu() {
        clear
        source ${scripts_dir}/support/support-Banner_func.sh
        echo

        printf "${OG}                        ${GN}Hack Containers really kick ass${OG}                  ${CY}\\n"
        echo
        printf "  ${GN}Select an option:${CY}\\n"
        echo
        printf "    ${WT}0)${CY}  ${PL}: \\n"
        printf "    ${WT}1)${CY}  ${PL}: \\n"
        printf "    ${WT}2)${CY}  ${PL}: \\n"
        printf "    ${WT}3)${CY}  ${PL}: \\n"
        printf "    ${WT}4)${CY}  ${PL}: \\n"
        printf "    ${WT}5)${CY}  qBitTorrent${PL}: Torrent Download client for the tools listed above. \\n"
        printf "    ${WT}6)${GN}  Return to Main Menu${PL}\\n"
        printf "    ${WT}7)${RED}  [✘] Exit tool [✘]: Uhh, it just exits.\\n"
        printf "    ${WT}8)${GN}  Go Back\\n"
        echo
        printf "  ${GN}Selection ----> ${CY}\\n"
        read -n 1 -r hack_menu_sel
        case "$hack_menu_sel" in
        0)
                container=
                exists_func
                ;;
        1)
                container=
                exists_func
                ;;
        2)
                container=
                exists_func
                ;;
        3)
                container=
                exists_func
                ;;
        4)
                container=
                exists_func
                ;;
        5)
                container=qbittorrent
                exists_func
                ;;
        6) main_menu_func ;;
        7) exit 0 ;;
        8) source ${scripts_dir}/support/support-docker-launcher.sh ;;
        *) printf "${RED}Invalid selection.${CY}\\n" ;;
        esac
}

gametools_menu() {
        clear
        source ${scripts_dir}/support/support-Banner_func.sh
        echo

        printf "${OG}                        ${GN}Game Containers really kick ass${OG}                  ${CY}\\n"
        echo
        printf "  ${GN}Select an option:${CY}\\n"
        echo
        printf "    ${WT}0)${CY}  EmulatorJS${PL}: REQUIRED Indexer for the other Arr products below.\\n"
        printf "    ${WT}1)${CY}  Dolphin-emu${PL}: NVIDIA GPU supported, Wii and Gamecube emulator.\\n"
        printf "    ${WT}2)${CY}  Coming Soon ${PL}: \\n"
        printf "    ${WT}3)${CY}  Coming Soon ${PL}: \\n"
        printf "    ${WT}4)${CY}  Coming Soon ${PL}: \\n"
        printf "    ${WT}5)${CY}  qBitTorrent${PL}: Torrent Download client for the tools listed above. \\n"
        printf "    ${WT}6)${GN}  Return to Main Menu${PL}\\n"
        printf "    ${WT}7)${RED}  [✘] Exit tool [✘]: Uhh, it just exits.\\n"
        printf "    ${WT}8)${GN}  Go Back\\n"
        echo
        printf "  ${GN}Selection ----> ${CY}\\n"
        read -n 1 -r game_menu_sel
        case "$game_menu_sel" in
        0)
                container=emulatorjs
                exists_func
                ;;
        1)
                container=dolphin-emu-x11
                exists_func
                ;;
        2)
                container=
                exists_func
                ;;
        3)
                container=
                exists_func
                ;;
        4)
                container=
                exists_func
                ;;
        5)
                container=qbittorrent
                exists_func
                ;;
        6) main_menu_func ;;
        7) exit 0 ;;
        8) source ${scripts_dir}/support/support-docker-launcher.sh ;;
        *) printf "${RED}Invalid selection.${CY}\\n" ;;
        esac
}

mediatools_menu() {
        clear
        source ${scripts_dir}/support/support-Banner_func.sh
        echo

        printf "${OG}                      ${GN}Media Containers really kick ass${OG}                  ${CY}\n"
        echo
        printf "  ${GN}Select an option:${CY}\n"
        echo
        printf "    ${WT}0)${CY}  Prowlarr${PL}: REQUIRED Indexer for the other Arr products below.\\n"
        printf "    ${WT}1)${CY}  Sonarr${PL}: Torrent and Usenet search tool for TV Series\\n"
        printf "    ${WT}2)${CY}  Radarr${PL}: Torrent and Usenet search tool for Movies\\n"
        printf "    ${WT}3)${CY}  Lidarr${PL}: Torrent and Usenet search tool for Music\\n"
        printf "    ${WT}4)${CY}  Readarr${PL}: Torrent and Usenet search tool for Books and Audio Books \\n"
        printf "    ${WT}5)${CY}  qBitTorrent${PL}: Torrent Download client for the tools listed above. \\n"
        printf "    ${WT}6)${GN}  Return to Main Menu${PL}\\n"
        printf "    ${WT}7)${RED}  [✘] Exit tool [✘]: Uhh, it just exits.\\n"
        printf "    ${WT}8)${GN}  Go Back\\n"
        echo
        printf "  ${GN}Selection ----> ${CY}\n"
        read -n 1 -r media_menu_sel
        case "$media_menu_sel" in
        0)
                container=prowlarr
                exists_func
                ;;
        1)
                container=sonarr
                exists_func
                ;;
        2)
                container=radarr
                exists_func
                ;;
        3)
                container=lidarr
                exists_func
                ;;
        4)
                container=readarr
                exists_func
                ;;
        5)
                container=qbittorrent
                exists_func
                ;;
        6) main_menu_func ;;
        7) exit 0 ;;
        8) source ${scripts_dir}/support/support-docker-launcher.sh ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
        esac
}

mediatools_func() {
        while true; do
                mediatools_menu
                printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
                read -n 1 -r
        done
}

gametools_func() {
        while true; do
                gametools_menu
                printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
                read -n 1 -r
        done
}

hacktools_func() {
        while true; do
                hacktools_menu
                printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
                read -n 1 -r
        done
}

main_menu_func() {
        source ${scripts_dir}/install/menu-master.sh
}

main_menu() {
        clear
        source ${scripts_dir}/support/support-Banner_func.sh
        echo

        printf "${OG}                           ${GN}Containers really kick ass${OG}                  ${CY}\\n"
        echo
        printf "  ${GN}Select an option:${CY}\\n"
        echo
        printf "    ${WT}0)${CY}  SWAG${PL}: Secure Web App Gateway, nginx-based reverse proxy\\n"
        printf "    ${WT}1)${CY}  Heimdall${PL}: Slick, self-hosted web shortcut launcher\\n"
        printf "    ${WT}2)${CY}  Glances${PL}: Best sysinfo tool ever created\\n"
        printf "    ${WT}3)${CY}  HomeAssistant${PL}: Awesome and very powerful Smart Home automation tool\\n"
        printf "    ${WT}4)${CY}  Media Tools${PL}: Plex, qbittorrent and the Arr suite of apps \\n"
        printf "    ${WT}5)${CY}  Game Tools${PL}: EmulatorJS and Dolphin Wii Emulator [with NVIDIA GPU support]\\n"
        printf "    ${WT}6)${CY}  Hacking Tools${PL}: Containerized hack tools\\n"
        printf "    ${WT}7)${GN}  Return to Main Menu${PL}\\n"
        printf "    ${WT}8)${RED}  [✘] Exit tool [✘]: Uhh, it just exits.\\n"
        echo
        printf "  ${GN}Selection ----> ${CY}\n"
        read -n 1 -r main_menu_sel
        case "$main_menu_sel" in
        0)
                container=swag
                exists_func
                ;;
        1)
                container=heimdall
                exists_func
                ;;
        2)
                container=glances
                exists_func
                ;;
        3)
                container=homeassistant
                exists_func
                ;;
        4) mediatools_func ;;
        5) gametools_func ;;
        6) hacktools_func ;;
        7) main_menu_func ;;
        8) exit 0 ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
        esac
}

main() {
        # Main script logic

        clear
        source ${scripts_dir}/support/support-Banner_func.sh
if command -v docker>/dev/null; then
	  echo
        printf "   Welcome to the Easy Linux docker launcher.\\n"
        printf "   Here, you'll be able to pull and launch peconfigured Docker containers.\\n"
        echo
        printf "   Docker containers will be pulled and setup with these options: \\n"
        echo
        printf "    ${WT} [*] ${GN}All images installed to user defined Docker network,${WT} [$network]\\n"
        printf "    ${WT} [*] ${GN}All images installed to location ${WT}"${appd_dir}"/[container]\\n"
        printf "    ${WT} [*] ${GN}All images created with ${WT}PUID=$(id -u) and PGID=$(id -g) ${GN}(your PUID & PGID is currently ${WT}$(id -u) and $(id -g))\\n${CY}"
        printf "    ${WT} [*] ${GN}All images created with ${WT}Timezone = America/Chicago${GN}.${OG}\\n"
        echo
        read -n 1 -r -p "   Do you [A]ccept the defaults or do you want to [c]hange values? [A/c] " dockopt
        printf " \\n"
        dockopt=${dockopt:-A}
        if [[ "${dockopt}" =~ ^[aA]$ ]]; then
                printf "  ${GN}Options Accepted.  Continuing.\\n"
        elif [[ "${dockopt}" =~ ^[cC]$ ]]; then
                printf "   ${OG}The following screen will contain the editable options at the beginning \\n"
                printf "   of the file. Change your options and rerun this script.\\n${NC}"
                read -n 1 -r -p "     Press any key to continue." anyk
                printf " \\n"
                if command -v nano >/dev/null; then
                        nano $scripts_dir/support/support-docker-launcher.sh
                        exit 0
                else
                        sudo apt update
                        sudo apt install -y nano
                        nano $scripts_dir/support/support-docker-launcher.sh
                fi
        else
                printf " Invalid selection. Valid options are A or C.\\n"
        fi
        echo

        network_func
        while true; do
                main_menu
                printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
                read -n 1 -r
        done
else
	printf "  ${RED}You are in the wrong place. Come see me after installing Docker.\\n"
	source ${scripts_dir}/support/support-docker.sh
fi
}

main

