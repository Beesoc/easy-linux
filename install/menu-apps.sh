#!/bin/bash
#
#
#shellcheck source=".envrc"
#shellcheck source="source/Prompt_func.sh"
#shellcheck source="support/Banner_func.sh"
source ".envrc"
set -e
#
clear
#
scripts_dir=/opt/easy-linux
install_compiled=$HOME/compiled
install_keyrings=

  if [ ! -d ${scripts_dir} ]; then
        sudo mkdir ${scripts_dir}
        sudo chown -Rf 1000:0 "${scripts_dir}"
  fi
  
options=("Hacking Tool" "Docker Desktop" "Downloads" "Pwnagotchi" "Main Menu" "Exit")
#
source "support/Banner_func.sh"
install-apps_options_func() {
  printf "  \\n                     ${CY}[???]${CY} Please select an option: ${CY}[???]${CY}\\n  \\n"
  printf "  ${OG} 1] ${GN}Docker Desktop${OG}                    20] ${GN}Install Wifite\\n "
  printf "  ${OG} 2] ${GN}Hacking Tool${OG}                      21] ${GN}Install The Fat Rat \\n"
  printf "  ${OG} 3] ${GN}Downloads${OG}                               \\n"
  printf "  ${OG} 4] ${GN}Pwnagotchi ${CY}                             \\n"
  printf "  99]${GN} Display System Information                     ${RED} [✘] Exit tool [✘]${NC}\\n"  
  printf " \\n"
    source "source/Prompt_func.sh"
  printf "${GN}   ---->"
# Read user input and display the appropriate submenu
read -r choice
  printf "  ${LB}\\n"
#  printf "  ${LB}\\n"
if [[ ${choice} == 1 ]]; then  
    clear
    source "support/Banner_func.sh"
    printf "${YW}\\n\\n           You chose Docker Desktop. Highly recommended. Docker runs apps in\\n\\n      "
    printf "\\n           virtual containers. This eliminates problems with dependencies and corrupt\\n\\n      "
    printf "\\n           installations.\\n" 
    source support/Prompt_func.sh
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.\\n"
      read -r -n1 -s -t 60
      clear
      docker_func
      #    Hacking_menu
elif [[ ${choice} == 2 ]]; then  
    clear
    printf "${YW}\\n\\n           You chose Hacking Tool. Download and use the hacking tool featured\\n"
    printf "\\n           in Mr. Robot. This tool has MANY tools built into it.  This is a definite \\n"
    printf "\\n           must install.\\n" 
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.\\n"
      read -r -n1 -s -t 60
      clear
      hacking_tool_func
#    Customize_menu
    bash /${scripts_dir}/install-customize.sh
elif [[ ${choice} == 3 ]]; then  
    clear
    printf "${YW}\\n\\n           You chose Downloads. [!!!]This menu is coming soon. You can continue\\n"
    printf "\\n           but know that you may experience bugs or other weird shit.  ${GN}You\\n"
    printf "\\n           have been warned. [!!!]\\n" 
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.\\n"
      read -r -n1 -s -t 60
      clear
      #    Download_menu
    bash ${scripts_dir}install-download.sh
elif [[ ${choice} == 4 ]]; then  
    printf "${YW}      You chose Pwnagotchi. \\n "
    clear
#    Pwnagotchi_menu
    bash ./install-backup_pwn-script.sh
elif [[ ${choice} == 20 ]]; then  
    printf "${YW}      You chose to install Wifite. \\n "
    clear
#    Sysinfo_menu
    source "support/Banner_func.sh"
    source "support/install-wifite.sh"
    printf "Show sys info"
elif [[ ${choice} == 21 ]]; then  
    printf "${YW}      You chose to install the Fat Rat. \\n "
    clear
#    Sysinfo_menu
    source "support/Banner_func.sh"
    source "support/install-fatrat.sh"
elif [[ ${choice} == 99 ]]; then  
    printf "${YW}      You chose System Information. \\n "
    clear
#    Sysinfo_menu
    source "support/Banner_func.sh"
    source "support/install-sysinfo.sh"
elif [[ ${choice} == 0 ]]; then  
#    Exit_menu
    clear
    source support/Banner_func.sh
    printf "${RED}0. [✘] Exit tool [✘]${NC} \\n"
    exit 1
else
    printf "   ${RED}Invalid Selection"
fi
}

hacking_tool_func() {
printf "Installing Hacking Tool...${NC}\n"
  if [[ -d ${install_compiled} ]]; then
        printf " \n";
          cd compiled
          return 1
          printf "  \n";
  elif [[ ! -d ${install_compiled} ]]; then      
          mkdir ~/compiled 
          cd compiled
  else
       printf "Invalid Selection"
  fi  
  sudo git clone https://github.com/Z4nzu/hackingtool.git
  cd hackingtool
  sudo pip3 install -r requirements.txt
  bash install.sh
}#
#

docker_func() {
printf "${OG}install docker requirements, but first...\n"
printf "General maintenance: sudo apt --fix-broken install -y${NC}\n"
  sudo apt --fix-broken install -y
  sudo apt install -y docker docker-compose wmdocker python3-dockerpty docker.io uidmap rootlesskit golang-github-rootless-containers-rootlesskit-dev containerd runc tini cgroupfs-mount needrestart golang-github-gofrs-flock-dev golang-github-gorilla-mux-dev golang-github-insomniacslk-dhcp-dev golang-github-moby-sys-dev golang-github-sirupsen-logrus-dev golang-golang-x-sys-dev libsubid4
  sudo apt --fix-broken install -y
  printf "${OG}Install Docker-desktop requirements QEMU${NC}\n"
  sudo apt install -y qemu-system-x86
  printf "${OG}Installing kernel modules for kvm_intel and add kvm to your Groups.${NC}\n"
  sudo modprobe kvm_intel
  sudo usermod -aG kvm $USER 
  sudo usermod -aG kvm root
  sudo apt install -y docker.io sen skopeo ruby-docker-api python3-dockerpycreds python3-ck podman podman-compose libnss-docker golang-github-opencontainers-runc-dev golang-github-fsouza-go-dockerclient-dev golang-github-docker-notary-dev golang-github-containers-image-dev golang-docker-credential-helpers elpa-dockerfile-mode due docker-registry distrobox crun catatonit buildah auto-apt-proxy
  sudo apt remove -y docker-desktop
  rm -r $HOME/.docker/desktop
  sudo rm /usr/local/bin/com.docker.cli
  sudo apt remove -y docker-desktop
  sudo apt --fix-broken install -y
  sudo apt install -y gnome-terminal locate plocate
  sudo docker completion bash && docker completion zsh
  printf "${OG}Grab docker's key and install docker-ce.${NC}\n"
  sudo apt install -y ca-certificates curl gnupg lsb-release
  if [ -d $install_keyrings ]; then
        printf " \n";
          cd $install_keyrings
        printf "  \n";
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
printf  "${OG}Install Docker Desktop${NC}\n"
  wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.17.0-amd64.deb
  sudo dpkg -i ./docker-desktop-4.17.0-amd64.deb
  sudo /opt/docker-desktop/bin/com.docker.admin completion bash
  sudo /opt/docker-desktop/bin/com.docker.admin completion zsh
  sudo apt --fix-broken install -y
  sudo apt autoremove -y
  systemctl --user start docker-desktop
}
standard_apps_func() {
  clear
Banner_func
    printf "${OG}  \\n"
    printf "      Installing some of my favorite [ Aptitude, ncdu, htop, git ] and ${WT}known \\n"
    printf "  required${OG} [ ${WT}python3-pip, python3-numpy ${OG}] apps.\\n ${GN}"
      sudo apt install -y aptitude ncdu git ncdu geany geany-plugins htop aircrack-ng airmon-ng;
    printf "  \\n" 
      printf "${OG}Installing additional nano lints.${NC}\\n"
  if [ -d $install_compiled ]; then
        printf " \\n";
          cd compiled
        echo "  \\n";
        else
          mkdir ~/compiled
          cd compiled
        fi
          git clone https://github.com/scopatz/nanorc.git
          cd nanorc
          sudo cp *.nanorc /usr/share/nano
          sudo cp ./shellcheck.sh /usr/bin
          sudo rm -r ~/compiled/nanorc/
}
install_apps_func() {
clear
source support/Banner_func
printf "  ${OG}Select which app you would like to install.\\n" 

select option in "${options[@]}"; do
    case ${option} in
        "Hacking Tool")
            clear
            Banner_func
            printf " ${OG}\\nInstalling Hacking Tool\\n"
            hacking_tool_func
            ;;
        "Docker Desktop")
            clear
            Banner_func
            printf " ${OG}\\nInstalling Docker Desktop\\n"
            docker_func
            ;;
        "Blah")
            clear
            Banner_func
            printf " ${OG}\\nBlah\\n"
            echo "${GN}You selected SBlah\\n"
            break
            ;;
         "Main Menu")
            clear
			bash ${scripts_dir}/install-master.sh
            echo "${OG}You selected Main Menu\\n${CY}"
            ;;
          "Exit")
          clear
            echo "${RED}You selected Exit${OG}\\n"
			exit 1
            ;;
        *)
            echo "${RED}Invalid option\\n${CY}"
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

clear
source support/Banner_func.sh
printf "    ${CY}First, we will $(WT)update/upgrade ${CY}all packages.\\n"
printf "    ${RED}[!!!] $[YW]IMPORTANT CHOICE ${RED}[!!!] "
printf "  ${GN}---->   ${CY}Enter the ${WT}C ${CY}key to continue for ${GN}ANYTHING EXCEPT${CY} a Pwnagotchi.\\n"
printf "  ${GN}---->   ${CY}If youre using a Pwnagotchi, enter P to continue.{NC}\\n${CY}"
printf "  ${YW}[!!!] ${CY}DONT UPDATE/UPGRADE A PWNAGOTCHI, ENTER P ${YW}[!!!]${NC}"

read -r -p "[P]wnagotchi or [C]ontinue with ANY other Linux distro?" install-choice
  if [[ ${install-choice} = "c" ]] || [[ ${install-choice} = "C" ]]; then
    sudo apt update && sudo apt upgrade -y
  elif [[ ${install-choice} = "p" ]] || [[ ${install-choice} = "P" ]]; then
    install-app_options_func
  fi
}

main
standard_apps_func
install_apps_func
hacking_tool_func
docker_func
 if [[  $(hostname) = "updates" ]]; then
        personal_func
    else
        printf "Easter egg for Beesoc only triggered"
 fi
  clear
  printf "                        ${YW}Summary of changes made by this script.${WT}   \n  " 
  printf "                   [ Update/Upgrade all packages ].....${GN}[✔] Successfully Installed [✔]${WT}\n";
  printf "                           [ Install HackingTool ].....${GN}[✔] Successfully Installed [✔]${WT}\n";
  printf "                   [ Docker Desktop Dependencies ].....${GN}[✔] Successfully Installed [✔]${WT}\n";
  printf "                        [ Install Docker Desktop ].....${GN}[✔] Successfully Installed [✔]${WT}\n";
  printf "                 [ Install Additional Nano Lints ].....${GN}[✔] Successfully Installed [✔]${WT}\n";
printf "  Press M to return to the Main Menu."
read -r menu_choice
 if [[  ${menu_choice} = "m" ]] || [[ ${menu_choice} = "M" ]]; then
        printf " \\n";
        bash ./install-master.sh
  else
          printf " Invalid Selection"
fi
 if [[  $(hostname) = "updates" ]]; then
        personal_func
        else
        bash ./install-master.sh
  fi
