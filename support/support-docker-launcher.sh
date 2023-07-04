#!/bin/bash
scripts_dir=/opt/easy-linux
docker_src=/opt/easy-linux/support/misc/docker

set -e

source "${scripts_dir}/.envrc"
source "${scripts_dir}/support/.whoami.sh" >/dev/null
#trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT

# Version: 0.0.3

dolphin_func() {
GPU_DEVICES=$( \
    echo "$( \
        find /dev -maxdepth 1 -regextype posix-extended -iregex '.+/nvidia([0-9]|ctl|-modeset)' \
            | grep --color=never '.' \
          || echo '/dev/dri'\
      )" \
      | sed -E "s/^/--device /" \
  )

# get the xdg runtime dir
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# create the container
docker create \
  --name dolphin-emu \
  --security-opt apparmor:unconfined \
  --net host \
  --shm-size 128M \
  --device /dev/input \
  --device /dev/snd \
  $GPU_DEVICES \
  -v $HOME/.${container}/Config:/config \
  -v $HOME/.${container}:/data \
  -v $HOME/Games/GameCube:/gc:ro \
  -v $HOME/Games/Wii:/wii:ro \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e DISPLAY=unix$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v /etc/machine-id:/etc/machine-id:ro \
  -v $HOME/.config/pulse:/home/ubuntu/.config/pulse:ro \
  -v $XDG_RUNTIME_DIR:/run/user/$(id -u)/pulse:ro \
  -v $XDG_RUNTIME_DIR/bus:$XDG_RUNTIME_DIR/bus:ro \
  -v /var/lib/dbus/machine-id:/var/lib/dbus/machine-id:ro \
  -v /run/dbus:/run/dbus:ro \
  -v /run/udev/data:/run/udev/data:ro \
  -v /etc/localtime:/etc/localtime:ro \
  andrewmackrodt/${container}

}

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
        elif [[ $(docker ps -a | grep "${container}" -c) -eq 0 ]] && [[ $(docker ps | grep "${container}" -c) -eq 0 ]]; then
                printf "  ${OG}Previous container not found for ${WT}${container}\\n${OG}"
                printf "  Starting requested container, ${WT}"${container}".\\n"
        else
                printf "  ${WT}${container} ${GN}status unknown. Starting Container.\\n"
        fi
        docker-compose up -d
        docker network connect ${defnet} ${container} 
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
if [[ "${container}" != "diyhue" ]]; then docker_up_func; fi

}

network_func() {
        if [[ ! -d $(docker network ls | grep "lsio") >/dev/null ]]; then
                sudo docker network create ${defnet}
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
                dolphin_func
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

diyhue_func() {
container=diyhue
# Install diyHUE (https://diyhue.readthedocs.io/en/latest/getting_started.html#docker-install)
exists_func
docker run -d --name ${container} --restart=always --network=host -e MAC=${diyhue_mac} -v /opt/appdata/${container}/config:/opt/hue-emulator/config diyhue/core:latest
exit 0
}

hacktools_func() {
        while true; do
                hacktools_menu
                printf "${CY} Press ${WT}any key ${CY}to return to ${WT}Main Menu${CY}.\\n"
                read -n 1 -r
        done
}

dockeronce_func() {
defnet=lsio
source ${scripts_dir}/support/.whoami.sh >/dev/null
  printf "  ${GN}Before you can spin up containers, a few questions...\\n"
  echo
  printf "  Press ${WT}any ${GN}key to continue${WT}\\n"
  echo
  read -n 1 -r confirm
  printf "${CY} Your PID is ${WT}$(id -u) ${CY}and your GID is ${WT}$(id -g)${CY}. This is correct if you're the main user.\\n${OG}"

  valid_choice=false
  while [[ "$valid_choice" == false ]]; do
    printf "${GN} [1/4]${OG}"
    read -n 1 -r -p "  Should this REQUIRED info be saved for use by Docker? [Y/n] " pgchoice
    pgchoice=${pgchoice:-Y}
    printf " \\n"
    if [[ "${pgchoice}" =~ ^[yY]$ ]]; then
      pid=$(id -u)
      gid=$(id -g)
      valid_choice=true
    elif [[ "${pgchoice}" =~ ^[nN]$ ]]; then
      printf "${RED} \\n Sorry, but Easy Linux Docker must be run and installed as the primary system user.\\n"
      printf " Please try again.\\n${NC}"
      exit 0
    else
      printf "${RED} Invalid Selection. Choose Y or N only.\\n${OG}"
    fi
  done

  valid_appdir=false
while [[ "$valid_appdir" == false ]]; do
  printf "\\n${GN} [3/4]  ${OG}Easy Linux base docker install folder is ${WT}[ "/opt/appdata" ]${OG}. Press Enter to accept \\n"
  read -r -p " or type in a new base location now. default: /opt/appdata ----> " appd_dir
  appd_dir="${appd_dir:-/opt/appdata}"
  if [[ ! -d $appd_dir ]]; then
     printf "${RED} Invalid docker base install directory. The folder must already exist.\\n"
  elif [[ -d ${appd_dir} ]]; then
  valid_appdir=true
  fi
done

#  valid_net=false
#  while [[ "$valid_net" == false ]]; do

  printf "\\n${GN} [4/4]  ${OG}To make Docker networking easier, all containers will run on a single, shared\\n"
  printf " network. ${WT}Don't change unless you know what you're doing. Default network: ${WT}${defnet}${GN}\\n${OG}"
  read -r -p " Press enter to proceed with default net name or type desired Docker network. " defnet
  defnet=${defnet:-lsio}

# Check if the network already exists
if docker network inspect "$defnet" >/dev/null 2>&1; then
    printf "The network '$defnet' already exists. Containers will be attached to $defnet."
else
    printf "The network '$defnet' doesn't exist. Creating..."
    docker network create '$defnet'
    printf "Network '$defnet' created."
fi

#valid_net=true
#done
  echo
  echo
  printf "${GN} Summary of Selections:\\n"
  echo
  printf "    ${WT}1] ${OG}PID=${pid}\\n"
  printf "    ${WT}2] ${OG}GID=${gid}\\n"
  printf "    ${WT}3] ${OG}App Install Base=$appd_dir\\n"
  printf "    ${WT}4] ${OG}Docker network=${defnet}\\n${GN}"
  echo
  read -n 1 -r -p " Do you accept these selections? [Y/n] ----> " daccept
  printf " \\n"
  daccept=${daccept:-Y}

  valid_choice=false
  while [[ "$valid_choice" == false ]]; do
    if [[ "${daccept}" =~ ^[nN]$ ]]; then
      printf "  ${RED}$USER selected not to continue with the chosen user selections. Exiting.\\n"
      exit 0
    elif [[ "${daccept}" =~ ^[yY]$ ]]; then
      dockeronce=1

    sudo sed -i "s#gid=.*#gid=${gid}#g" "${scripts_dir}/.envrc"
	sudo sed -i "s#pid=.*#pid=${pid}#g" "${scripts_dir}/.envrc"
	sudo sed -i "s#appd_dir=.*#appd_dir=${appd_dir}#g" "${scripts_dir}/.envrc"
	sudo sed -i "s#defnet=.*#defnet=${defnet}#g" "${scripts_dir}/.envrc"
	sudo sed -i "s#dockeronce=.*#dockeronce=${dockeronce}#g" "${scripts_dir}/.envrc"

    valid_choice=true
    main_menu
    else
      printf " ${RED}Invalid Selection. Options are Y or N.\\n"
    fi
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
	  printf "    ${WT}7)${CY}  DIY Hue${PL}: Philips Hue hub emulator for DIY Lights\\n"
	  printf "    ${WT}8)${GN}  Return to Main Menu${PL}\\n"
        printf "    ${WT}9)${RED}  [✘] Exit tool [✘]: Uhh, it just exits.\\n"
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
        7) diyhue_func ;;
        8) main_menu_func ;;
        9) exit 0 ;;
        *) printf "${RED}Invalid selection.${CY}\n" ;;
        esac
}

pre_func() {

printf "  ${CY}Welcome to the Easy Linux Docker Launcher.\\n"
if [[ ${dockeronce} -ne 1 ]]; then
	dockeronce_func
elif [[ ${dockeronce} -eq 1 ]]; then
      printf "  ${CY}The Docker wizard has already been ran. Do you want to \\n${OG}"
      read -n 1 -r -p "  reset settings and pick Docker options again? [y/N] ----> " redock 
	redock=${redock:-n}
	printf " \\n"
	if [[ "${redock}" =~ ^[yY]$ ]]; then
	   dockeronce_func
	elif [[ "${redock}" =~ ^[nN]$ ]]; then
         return 0
      else
         printf "${RED} Invalid Selection. Options are Y or N.\\n"
      fi
else
      dockeronce_func
fi
}

main() {
        # Main script logic
        clear
        source ${scripts_dir}/support/support-Banner_func.sh
echo 
pre_func

if command -v docker>/dev/null; then
	  echo
        printf "   Initial Easy Linux Docker Launcher setup wizard completed.\\n"
        printf "   Here, you\'ll be able to pull and launch peconfigured Docker containers.\\n"
        echo
        printf "   Docker containers will be pulled and setup with these options: \\n"
        timezone=$(cat /etc/timezone)
	echo
        printf "    ${WT} [*] ${GN}All images installed to user defined Docker network,${WT} [$defnet]\\n"
        printf "    ${WT} [*] ${GN}All images installed to location ${WT}"${appd_dir}"/[container]\\n"
        printf "    ${WT} [*] ${GN}All images created with ${WT}PUID=$(id -u) and PGID=$(id -g) ${GN}(your PUID & PGID is currently ${WT}$(id -u) and $(id -g))\\n${CY}"
        printf "    ${WT} [*] ${GN}All images created with ${WT}Timezone = $timezone${GN}.${OG}\\n"
        echo
        read -n 1 -r -p "   Do you [A]ccept these settings or do you want to [c]hange values? [A/c] " dockopt
        printf " \\n"
        dockopt=${dockopt:-A}
        if [[ "${dockopt}" =~ ^[aA]$ ]]; then
                printf "  ${GN}Options Accepted.  Continuing.\\n"
		timezone=$(cat /etc/timezone)
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

