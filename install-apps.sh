#!/bin/bash
#
set -e
#
clear
#
#RED='\e[1;31m'
#GN='\e[1;32m'
#YW='\e[1;33m'
#WT='\e[1;37m'
#OG='\e[1;93m'
#NC='\e[0m'
#
source ./.envrc

Prompt_func() {
    prompt_symbol=㉿
    prompt_color=${GN}
    info_color=${BL}
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
#        prompt_color='\[\033[;94m\]'
        prompt_color=${GN}
        info_color=${RED}
        # Skull emoji for root terminal
        prompt_symbol=💀
    fi

printf "${GN}┌──(${CY}$USER${prompt_symbol}$HOST${GN})-[${prompt_color}${PWD}${GN}]\\n"
printf "${GN}└─${CY}$ ${CY}\\n"

}

Banner_func() {
  printf "${WT}\\n
${OGH}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${OGG}${RED}
    ▄████▄${BK}╗    ${RED}▄████▄${BK}╗   ${RED}▄████▄${BK}╗    ${RED}▄████▄${BK}╗     ${RED}▄███▄${BK}╗     ${RED}▄███▄${BK}╗  ${RED}██${BK}╗  ${RED}▄████▄${BK}╗  ${OG}  
    ██${BK}═══${OG}██${BK}╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔════╝    ${OG}██${BK}╔══${OG}██${BK}╗   ${OG}██${BK}╔══${OG}▀${BK}╝   ${OG}▀${BK}╝ ${OG}██${BK}╔════╝${OG}    
    ██████${BK}╝    ${OG}█████${BK}╗    ${OG}█████${BK}╗     ${OG}▀████▄${BK}╗    ${OG}██${BK}║  ${OG}██${BK}║   ${OG}██${BK}║           ${OG}▀████▄${BK}╗${OG}    
    ██${BK}═══${OG}██    ${OG}██${BK}╔══╝${OG}    ██${BK}╔══╝      ╚═══${OG}██${BK}║   ${OG}██${BK}║  ${OG}██${BK}╝   ${OG}██${BK}║  ${OG}▄${BK}╗        ╚═══${OG}██${BK}║ ${OGF}  
    ▀████▀${BK}╝    ${OGF}▀████▀${BK}╗   ${OGF}▀████▀${BK}╗    ${OGF}▀████▀${BK}╝     ${OGF}▀███▀${BK}╝${OGF}     ▀███▀${BK}╝"${OGF}"       ▀████▀${BK}╝   ${BK} 
     ╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝      ${OGG}
    ▄████▄${BK}╗   ${OGG}▄█▄${BK}╗    ${OGG}▄███▄${BK}╗ ${OGG}█▄${BK}╗   ${OGG}▄█${BK}╗   ${OGG}▄█${BK}╗    ${OGG}▄█${BK}╗ ${OGG}▄█${BK}╗  ${OGG}█▄${BK}╗ ${OGG}▄█${BK}╗  ${OGG}▄█${BK}╗ ${OGG}██▄${BK}╗  ${OGG}▄██${BK}╗ ${GN}  
    ██${BK}╔═══╝  ${GN}██${BK}║${GN}██${BK}╗  ${GN}██${BK}╔═══╝  ${GN}██${BK}╗ ${GN}██${BK}╔╝   ${GN}██${BK}║    ${GN}██${BK}║ "${GN}"██▄${BK}╗ ${GN}██${BK}║ ${GN}██${BK}║  ${GN}██${BK}║  ${GN}▀██▄██▀${BK}╝${GN}    
    █████${BK}╗  ${GN}███▀███${BK}╗  ${GN}▀███▄${BK}╗   ${GN}████${BK}╔╝    ${GN}██${BK}║    ${GN}██${BK}║ ${GN}████▄██${BK}║ "${GN}"██${BK}║  ${GN}██${BK}║    ${GN}███${BK}║${GN}      
    ██${BK}╔══╝  ${GN}██${BK}║  ${GN}██${BK}║   ╚══${GN}██${BK}║   ${GN}██${BK}╔╝     ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██${BK}║${GN}▀███${BK}║ ${GN}██${BK}║  ${GN}██${BK}║  ${GN}▄██▀██▄${BK}╗    ${OGG}
    ▀████▀${BK}╝ ${OGG}██${BK}║  ${OGG}██${BK}║  ${OGG}▀███▀${BK}╝    ${OGG}██${BK}║      ${OGG}▀████${BK}╗ ${OGG}██${BK}║ ${OGG}██${BK}║  ${OGG}██${BK}║  ${OGG}▀███▀${BK}╝  ${OGG}██▀${BK}╝  ${OGG}▀██${BK}╗   ${BK}
     ╚═══╝  ╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═══╝ ╚═╝ ╚═╝  ╚═╝   ╚═╝    ╚═╝    ╚═╝   ${NC}${BK}
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄\\n"
printf "${NC}"
#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
  #
}
#install_compiled="${HOME}/compiled"
#install_keyrings="/etc/apt/keyrings"
#


hacking_tool_func() {
printf "Installing Hacking Tool...${NC}\n"
  if [[ -d ${install_compiled} ]]; then
        printf " \\n  ";
          cd ${install_compiled}
  fi
        printf "  \n  ";
    if [[ ! -d ${install_compiled} ]]; then      
          mkdir ${install_compiled} 
          cd ${install_compiled}
     else
       printf "  Invalid Selection"
     fi  
  sudo git clone https://github.com/Z4nzu/hackingtool.git
  cd hackingtool
  sudo pip3 install -r requirements.txt
  bash install.sh
}
#

docker_func() {
printf "  ${OG}install docker requirements, but first...\\n"
printf "  General maintenance: sudo apt --fix-broken install -y${NC}\\n"
  sudo apt --fix-broken install -y > /dev/null
  sudo apt install -y docker docker-compose wmdocker python3-dockerpty docker.io uidmap rootlesskit golang-github-rootless-containers-rootlesskit-dev containerd runc tini cgroupfs-mount needrestart golang-github-gofrs-flock-dev golang-github-gorilla-mux-dev golang-github-insomniacslk-dhcp-dev golang-github-moby-sys-dev golang-github-sirupsen-logrus-dev golang-golang-x-sys-dev libsubid4
  sudo apt --fix-broken install -y > /dev/null
  printf "  ${OG}Install Docker-desktop requirements QEMU${NC}\\n"
  sudo apt install -y qemu-system-x86
  printf "  ${OG}Installing kernel modules for kvm_intel and add kvm to your Groups.${NC} \\n"
  sudo modprobe kvm_intel
  sudo usermod -aG kvm $USER 
  sudo usermod -aG kvm root
  sudo apt install -y docker.io sen skopeo ruby-docker-api python3-dockerpycreds python3-ck podman podman-compose libnss-docker golang-github-opencontainers-runc-dev golang-github-fsouza-go-dockerclient-dev golang-github-docker-notary-dev golang-github-containers-image-dev golang-docker-credential-helpers elpa-dockerfile-mode due docker-registry distrobox crun catatonit buildah auto-apt-proxy
  sudo apt remove -y docker-desktop
  rm -r $HOME/.docker/desktop
  sudo rm /usr/local/bin/com.docker.cli
  sudo apt remove -y docker-desktop
  sudo apt --fix-broken install -y > /dev/null
  sudo apt install -y gnome-terminal locate plocate
  sudo docker completion bash
  sudo docker completion zsh
  printf "${OG}Grab docker's key and install docker-ce.${NC}\\n"
  sudo apt install -y ca-certificates curl gnupg lsb-release
  if [ -d $install_keyrings ]; then
        printf " \\n";
          cd $install_keyrings
        printf " \\n";
        else
          mkdir /etc/apt/keyrings
        fi
  sudo chmod 0755 /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "%s\n" "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" |\
sudo tee /etc/apt/sources.list.d/docker-ce.list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io pass
printf  "  ${OG}Install Docker Desktop${NC}\\n"
  wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.17.0-amd64.deb
  sudo dpkg -i ./docker-desktop-4.17.0-amd64.deb
  sudo /opt/docker-desktop/bin/com.docker.admin completion bash
  sudo /opt/docker-desktop/bin/com.docker.admin completion zsh
  sudo apt --fix-broken install -y > /dev/null
  sudo apt autoremove -y
  systemctl --user start docker-desktop
}
standard_apps_func() {
  clear
Banner_func
    printf "${CY}  \\n"
    printf "    Installing some of my favorite [ ${WT}Aptitude, ncdu, htop, git ${CY}] and ${WT}known \\n"
    printf "    required${CY} [ ${WT}python3-pip, python3-numpy ${CY}] apps.\\n ${GN}  "
      sudo apt install -y direnv aptitude ncdu git ncdu geany geany-plugins htop aircrack-ng makepasswd;
    printf "  \\n  " 
      printf "${OG}Installing additional nano lints.${NC}  \\n"
  if [ -d $install_compiled ]; then
        printf " \\n ";
          cd ${install_compiled}
        printf " \\n ";
        else
          mkdir ${install_compiled}
          cd ${install_compiled}
   fi
          mkdir ${install_compiled}/nano
          git clone https://github.com/scopatz/nanorc.git
          cd nanorc
          sudo cp *.nanorc /usr/share/nano
          sudo cp ./shellcheck.sh /usr/bin
          sudo rm -r ~/compiled/nanorc/
}
install_apps_func() {
clear
Banner_func

#read -p "  Select which app you would like to install. ---->  " select_app 
printf "Select app:  "

select option in "${options[@]}"; do
    case ${option} in
        "Hacking Tool")
            clear
            Banner_func
            printf "  ${OG}\\nInstalling Hacking Tool\\n"
            hacking_tool_func
            ;;
        "Docker Desktop")
            clear
            Banner_func
            printf "  ${OG}\\nInstalling Docker Desktop\\n"
            docker_func
            ;;
        "Blah")
            clear
            Banner_func
            printf "  ${OG}\\nBlah\\n"
            printf "${GN}You selected SBlah\\n"
            ;;
         "Main Menu")
            clear
			bash ${scripts_dir}/install-master.sh
            printf "    ${OG}You selected Main Menu\\n${CY}"
            ;;
          "Exit")
          clear
            printf "    ${RED}You selected Exit${OG}\\n"
			exit 1
            ;;
        *)
            printf "    ${RED}Invalid option\\n${CY}"
            ;;
    esac
done
}

personal_func() {
#####  Personal  #######
printf "${CY}Install Storm-Breaker"
  sudo apt install -y python3-requests python3-colorama python3-psutil
  cd /opt
  sudo git clone https://github.com/ultrasecurity/Storm-Breaker.git
  cd Storm-Breaker
  sudo bash ./install.sh
  cd storm-web
  sudo su
  rm config.php
  touch ./config.php
  echo "<?php

\$CONFIG = array (
    \"hidden\" => [
        \"fullname\" => \"hacker\",
        \"password\" => \"57aW48YwPn3@\",
    ],

);

?>" > config.php

exit
  printf "Install ngrok"
  cd ~/Downloads
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
  sudo tar xvzf ~/Downloads/ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
  printf "Go signup for an ngrok account.  Then use you key below"
  ngrok config add-authtoken 2NfhLccABPQaLZEPIQ2BHoqMEi1_HtwCjRDobFehPbTDohMW
}

main() {
  if [[ ! -d ${scripts_dir} ]]; then
        mkdir ${scripts_dir};   
  fi   
clear
Banner_func
printf "  ${OG}First, we will ${WT} update/upgrade ${OG}all packages. Press ${WT}any ${CY}key to continue \\n"
printf "  \\n${RED}Press [ctrl+c] to exit script.${NC}\\n ${CY} ----> """
  read -r -n1 -s -t 30
    sudo apt update && sudo apt upgrade -y
standard_apps_func
install_apps_func
hacking_tool_func
docker_func
 if [[  $(HOST) = "updates" ]]; then
        personal_func
 fi
  clear
  printf "                        ${YW}Summary of changes made by this script.${WT}   \\n  " 
  printf "                   [ Update/Upgrade all packages ].....${GN}[✔] Successfully Installed [✔]${WT}\\n";
  printf "                           [ Install HackingTool ].....${GN}[✔] Successfully Installed [✔]${WT}\\n";
  printf "                   [ Docker Desktop Dependencies ].....${GN}[✔] Successfully Installed [✔]${WT}\\n";
  printf "                        [ Install Docker Desktop ].....${GN}[✔] Successfully Installed [✔]${WT}\\n";
  printf "                 [ Install Additional Nano Lints ].....${GN}[✔] Successfully Installed [✔]${WT}\\n";
printf "  Press M to return to the Main Menu.${CY}\\n  ---->"
read -r menu_choice
 if [[ ${menu_choice} = "m" ]] || [[  ${menu_choice} = "M" ]]; then
        printf " \\n";
        bash ${scripts_dir}/install-master.sh
        else
          printf "${RED}  Invalid Selection"
fi
 if [[ $HOST = updates ]]; then
        personal_func
        else
        bash ${scripts_dir}/install-master.sh
        fi
}

main
