#!/bin/bash
# New app installer from Github
# Version: 0.0.2

set -e

BK='\e[0;44;30m'
RED='\e[1;31m'
GN='\e[1;32m'
CY='\e[1;36m'
WT='\e[1;37m'
OG='\e[1;93m'
OGG='\e[0;32;44m'
OGF='\e[0;33;44m'
OGH='\e[0;30;44m'
NC='\e[0m'

Banner_func() {
  printf "${WT}\\n"
printf "${OGH}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${OGG}${RED}\\n"
printf "    ▄████▄${BK}╗    ${RED}▄████▄${BK}╗   ${RED}▄████▄${BK}╗    ${RED}▄████▄${BK}╗     ${RED}▄███▄${BK}╗     ${RED}▄███▄${BK}╗  ${RED}██${BK}╗  ${RED}▄████▄${BK}╗    ${NC}\\n"
printf "${OGG}    ${OG}██${BK}═══${OG}██${BK}╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔════╝    ${OG}██${BK}╔══${OG}██${BK}╗   ${OG}██${BK}╔══${OG}▀${BK}╝   ${OG}▀${BK}╝ ${OG}██${BK}╔════╝${NC}${OGG}    ${NC}\\n"
printf "${OGG}    ${OG}██████${BK}╝    ${OG}█████${BK}╗    ${OG}█████${BK}╗     ${OG}▀████▄${BK}╗    ${OG}██${BK}║  ${OG}██${BK}║   ${OG}██${BK}║           ${OG}▀████▄${BK}╗${OGG}    ${NC}\\n${NC}"
printf "${OGG}    ${OG}██${BK}═══${OG}██    ${OG}██${BK}╔══╝${OG}    ██${BK}╔══╝      ╚═══${OG}██${BK}║   ${OG}██${BK}║  ${OG}██${BK}╝   ${OG}██${BK}║  ${OG}▄${BK}╗        ╚═══${OG}██${BK}║${OGF}   \\n"
printf "    ${OGF}▀████▀${BK}╝    ${OGF}▀████▀${BK}╗   ${OGF}▀████▀${BK}╗    ${OGF}▀████▀${BK}╝     ${OGF}▀███▀${BK}╝${OGF}     ▀███▀${BK}╝${OGF}       ▀████▀${BK}╝   ${BK} \\n"
printf "     ${BK}╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝      \\n${OGG}"
printf "${OGG}    ${OGG}▄████▄${BK}╗   ${OGG}▄█▄${BK}╗    ${OGG}▄███▄${BK}╗  ${OGG}██${BK}╗   ${OGG}██${BK}╗   ${OGG}▄█${BK}╗    ${OGG}▄█${BK}╗ ${OGG}▄█${BK}╗  ${OGG}▄█${BK}╗ ${OGG}▄█${BK}╗ ${OGG} ▄█${BK}╗ ${OGG}██▄${BK}╗  ${OGG}▄██${BK}╗  \\n"
printf "${GN}    ${GN}██${BK}╔═══╝  ${GN}██${BK}║${GN}██${BK}╗  ${GN}██${BK}╔═══╝  ${GN}▀██▄▄██▀${BK}╝   ${GN}██${BK}║    ${GN}██${BK}║ ${GN}█${BK}${GN}██▄${BK}╗${GN}██${BK}║${GN} ██${BK}║  ${GN}██${BK}║  ${GN}▀██▄██▀${BK}╝${GN}   \\n"
printf "${OGG}    ${GN}█████${BK}╗  ${GN}███▀███${BK}║  ${GN}▀███▄${BK}╗    ${GN}▀██▀${BK}╔╝    ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██▀████${BK}║ ${GN}██${BK}║  ${GN}██${BK}║   ${GN} ███${BK}║     \\n  "  
printf "  ${GN}██${BK}╔══╝  ${GN}██${BK}╔══${GN}${OGG}${GN}██${BK}║      ${GN}██${BK}║    ${GN}██${BK}║      ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██${BK}║ ${GN}███${BK}║ ${GN}██${BK}║  ${GN}██${BK}║  ${GN}▄██${BK}${GN}▀██${BK}${BK}╗    \\n"
printf "  ${WT}${OGG}   ${WT}▀███▀${BK}╝ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝     ${WT}██${BK}║      ${WT}▀████${BK}╗ ${WT}██${BK}║ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝  ${WT}██▀${BK}╝  ${WT}▀██${BK}╗  \\n   ${BK}"
printf "${OGG}  ${BK} ╚══╝  ${BK}╚═╝  ${BK}╚═╝   ${BK}╚═╝       ${BK}╚═╝       ${BK}╚═══╝ ${BK}╚═╝ ${BK}╚═╝  ${BK}╚═╝   ${BK}╚══╝   ${BK}╚═╝    ${BK}╚═╝  ${OGH}
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄\\n"
printf "${NC}${CY}"

#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
  #
}                                

Banner_func

direnv_func() {
# Step 3 or skip function.
               read -n 1 -p "DIRENV is not installed. Do you want me to install it? [Y/n] " choicedirenv
        choicedirenv=${choicedirenv:-Y}
                if [[ $choicedirenv =~ ^[Yy]$ ]]; then
                    printf "${GN}  Continuing..." 
                    sleep 1
                    printf "  This step may take a few minutes..."
                    sleep 1
                    printf "  Please wait."
                    sudo apt update
                    sudo apt install -y direnv
                else
                   printf "${GN} Not Needed.  Continuing."
                
                fi
       check_directories_func
}

install_func() {
# Step 5 function.
printf "${WT}\\n  [*] ${GN}Dependencies satisfied.\\n\\n  ${WT}[*]${WT} "
sleep 1
read -n 1 -p "Do you want to install Easy Linux Loader? [Y/n] " choiceez
          choiceez=${choiceez:-Y}
            if [[ $choiceez =~ ^[Yy]$ ]]; then
          #if [[ $choiceez = "Y" ]] || [[ $choiceez = "y" ]]; then
              printf "\\n${WT}  [*] ${CY}Installation confirmed..."; sleep 1; printf "..Please wait.."
              sleep 1
            elif [[ $choiceez =~ ^[Nn]$ ]]; then
            #elif [[ $choiceez = "n" ]] || [[ $choiceez = "N" ]]; then
              printf "\\n${RED}  [*] ${OG}Installation rejected..."
              sleep 1 
              printf "..Please wait.."
              exit 0
            else
              printf "\\n${RED}  [*]  Invalid Selection. Exiting."
              exit 0
            fi
     git_files_func
}

check_directories_func() {
# Step 2 or 4 function.
if [[ -d /opt/easy-linux ]]; then
    printf "  ${WT}[*] ${GN}/opt/easy-linux ${CY}directory found.\\n"
    printf "  ${WT}[*] ${GN}Removing and recloning repository." 
    sleep 1
    sudo rm -fr /opt/easy-linux
elif [[ ! -d /opt/easy-linux ]]; then
#    sudo chown -v 1000:1000 /opt
    printf " ${WT} [*] ${WT}/opt/easy-linux ${CY}directory not found. Cloning repo into that folder."; sleep 1
fi  
install_func

}
main() {
# 1.  script starts executing here.
clear
Banner_func

printf "\\n${OG}    Welcome to the Installer for Beesoc's Easy Linux    Press ${RED}[ctrl+c] ${OG}to cancel\\n${CY}\\n    " 

read -n 1 -p "Do you want to check dependencies for Beesoc's Easy Linux Loader? [Y/n] " install
install=${install:-Y}
if [[ $install =~ ^[Yy]$ ]]; then
  printf "\\n ${WT} [*] ${GN}Loading...Please Wait...\\n"
else
  printf "  ${RED}   Exiting.\\n"
  exit 0
fi
sudo apt install -y bc lm-sensors curl > /dev/null

clear
   Banner_func
# check for requirements.
    if command -v /usr/bin/direnv >/dev/null 2>&1; then
       check_directories_func
    else
    direnv_func
    fi
}



git_files_func() {
# step 6 function.
  printf "  ${WT} \\n  [*] ${GN}Cloning remote Git repo.${OG}\\n  "
  sleep 1
  sudo git clone https://github.com/Beesoc/easy-linux.git /opt/easy-linux

sudo chown -v 1000:0 /opt/easy-linux
sudo chmod +x /opt/easy-linux/support/*.sh
sudo mv /opt/easy-linux/install/easy-linux.desktop /usr/share/applications/
sudo mv -t /opt/easy-linux /opt/easy-linux/install/*
sudo chmod +x /opt/easy-linux/*.sh
sudo cp -f /opt/easy-linux/menu-master.sh /usr/bin/

cleanup_func

}

cleanup_func() {
# Step 7 function. End.
printf "${WT} [*] ${CY}Please Wait while I cleanup some files used in the installation -${NC} \\n"
printf "${WT}..."; sleep 1; printf "...Almost done\\n" 

  clear
  Banner_func
  printf "   ${WT}[*] ${GN}Beesoc's Easy Linux Loader has been installed.\\n\\n" 
  printf "   ${CY}Use the option on your ${WT}Apps menu ${CY}or enter [ ${WT}menu-master.sh${CY} ]\\n"
  printf "   from ${WT}any Terminal ${CY}to access. Thanks for using ${WT}Beesoc's Easy Linux Loader!\\n${CY}" 

printf "\\n${WT}   $username,${CY} "
read -n 1 -p "would you like to launch Easy Linux now? [Y/n] " launchnow
launchnow=${launchnow:-Y}
if [[ $launchnow =~ ^[Yy]$ ]]; then
  printf "${GN}\\n   Starting Beesoc's Easy Linux now....\\n"
  source /opt/easy-linux/menu-master.sh
else
  printf "    ${RED}Exiting.\\n"
  exit 0
fi
}

main
cleanup_func
