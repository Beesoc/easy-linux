#!/bin/bash
# New app installer from Github
function help {
  echo 
  echo "Usage: $0 [options]"
  echo "  This is the help menu for the app installer for Beesoc's Easy Linux Loader."
  echo "  No extra parameters can be applied to the installer at this point."
  echo "  Make it executable with 'sudo chmod +x INSTALLv2.sh' then run with .INSTALLv2.sh"
  echo
  echo
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


cleanup_func() {
# Step 7 function. End.
printf "${WT} [*] ${CY}Please Wait while I cleanup some files used in the installation -${NC} \\n"
printf "${WT}..."; sleep 1; printf "...Almost done\\n" 

  clear
  Banner_func
  printf "   ${CY}[*] ${WT}Beesoc's Easy Linux Loader ${GN}has been installed.\\n\\n" 
  printf "   ${CY}Use the option on your ${WT}Apps menu ${CY}or enter [ ${WT}menu-master.sh${CY} ]\\n"
  printf "   from ${WT}any Terminal ${CY}to access. Thanks for using ${WT}Beesoc's Easy Linux Loader!\\n${CY}" 

        sudo echo "export COLORTERM=truecolor" >> ~/.bashrc && sudo echo "export COLORTERM=truecolor" >> ~/.zshrc
        sudo echo "export COLORFGBG=15;0" >> ~/.bashrc && sudo echo "export COLORFGBG=15;0" >> ~/.zshrc
printf "\\n${CY}      Hey ${WT}$USER${CY}, would you like to launch \\n${WT}       "
read -n 1 -p "Beesoc's Easy Linux Loader now? [Y/n] " launchnow
launchnow=${launchnow:-Y}
if [[ $launchnow =~ ^[Yy]$ ]]; then
  printf "${GN}\\n   Starting Beesoc's Easy Linux now....\\n"
        source /opt/easy-linux/menu-master.sh
else
  printf "    ${RED}Exiting.\\n"
  exit 0
fi
}

git_files_func() {
# step 6 function.
  printf "  ${WT} \\n  [*] ${GN}Cloning remote Git repo.${OG}\\n  "; sleep 1
  sudo git clone https://github.com/Beesoc/easy-linux.git /opt/easy-linux

sudo chown -vR 1000:0 /opt/easy-linux
sudo chmod +x /opt/easy-linux/support/*.sh
sudo mv /opt/easy-linux/install/easy-linux.desktop /usr/share/applications/
sudo mv -t /opt/easy-linux /opt/easy-linux/install/*
sudo chmod +x /opt/easy-linux/*.sh
sudo cp -f /opt/easy-linux/menu-master.sh /usr/bin/

cleanup_func
}

install_func() {
# Step 5 function.
# Banner_func
printf "${WT}\\n  [*] ${GN}Dependencies satisfied.\\n\\n  ${WT}[*]${WT} "; sleep 1
read -n 1 -p "Do you want to install Easy Linux Loader? [Y/n] " choiceez
          choiceez=${choiceez:-Y}
            if [[ "$choiceez" =~ ^[Yy]$ ]]; then
          #if [[ $choiceez = "Y" ]] || [[ $choiceez = "y" ]]; then
              printf "\\n${WT}  [*] ${CY}Installation confirmed..."; sleep 1; printf "..Please wait..\\n";  sleep 1
            elif [[ "$choiceez" =~ ^[Nn]$ ]]; then
            #elif [[ $choiceez = "n" ]] || [[ $choiceez = "N" ]]; then
              printf "\\n${RED}  [*] ${OG}Installation rejected...\\n"; sleep 1; printf "${CY}..Please wait...\\n"
              exit 0
            else
              printf "\\n${WT}  [*]  ${RED}Invalid Selection. Exiting.\\n"
              exit 0
            fi
     git_files_func
}
check_directories_func() {
# Step 2 or 4 function.
if [[ -d /opt/easy-linux ]]; then
    printf "  ${WT}[*] ${GN}/opt/easy-linux ${CY}directory found.\\n"
    printf "  ${WT}[*] ${GN}Removing and recloning repository.\\n" 
    sleep 1
    sudo rm -fr /opt/easy-linux
elif [[ ! -d /opt/easy-linux ]]; then
#    sudo chown -v 1000:1000 /opt
    printf " ${WT} [*] ${WT}/opt/easy-linux ${CY}directory not found. Cloning repo into that folder.\\n"; sleep 1
fi  
install_func
}

direnv_func() {
# Step 3 or skip function.
               read -n 1 -p "DIRENV is not installed. Do you want me to install it? [Y/n] " choicedirenv
        choicedirenv=${choicedirenv:-Y}
                if [[ "$choicedirenv" =~ ^[Yy]$ ]]; then
                    printf "${GN}  Continuing...\\n" 
                    sleep 1
                    printf "  ${OG}This step may take a few minutes...\\n"
                    sleep 1
                    printf "  ${OG}Please wait.\\n"
                    sudo apt update
                    sudo apt install -y direnv
                else
                   printf "${GN} Not Needed.  Continuing.\\n"
                
                fi
       check_directories_func
}

main() {
# 1.  script starts executing here.
clear
Banner_func

printf "\\n${GN}    Welcome to the Installer for ${WT}Beesoc's Easy Linux${GN}    Press ${RED}[ctrl+c] ${GN}to cancel\\n${CY}\\n    " 

read -n 1 -p "Do you want to check dependencies for Beesoc's Easy Linux Loader? [Y/n] " install
install=${install:-Y}
if [[ "$install" =~ ^[Yy]$ ]]; then
  printf "\\n  ${WT}[*] ${CY}Loading...Please Wait...\\n"
else
  printf "  ${RED}   Exiting.\\n"
  exit 0
fi
# check for requirements.
    if $(command -v /usr/bin/direnv >/dev/null 2>&1); then
       check_directories_func
    else
    direnv_func
    fi
}

main

