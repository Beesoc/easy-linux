#!/bin/bash
# New app installer from Github
# Version: 0.0.2
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
clear
Banner_func() {
  printf "${WT}\\n"
printf "${OGH}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${OGG}${RED}\\n"
printf "    ▄████▄${BK}╗    ${RED}▄████▄${BK}╗   ${RED}▄████▄${BK}╗    ${RED}▄████▄${BK}╗     ${RED}▄███▄${BK}╗     ${RED}▄███▄${BK}╗  ${RED}██${BK}╗  ${RED}▄████▄${BK}╗    ${NC}\\n"
printf "${OGG}    ${OG}██${BK}═══${OG}██${BK}╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔════╝    ${OG}██${BK}╔══${OG}██${BK}╗   ${OG}██${BK}╔══${OG}▀${BK}╝   ${OG}▀${BK}╝ ${OG}██${BK}╔════╝${NC}${OGG}    ${NC}\\n"
printf "${OGG}    ${OG}██████${BK}╝    ${OG}█████${BK}╗    ${OG}█████${BK}╗     ${OG}▀████▄${BK}╗    ${OG}██${BK}║  ${OG}██${BK}║   ${OG}██${BK}║           ${OG}▀████▄${BK}╗${OGG}    ${NC}\\n${NC}"
printf "${OGG}    ${OG}██${BK}═══${OG}██    ${OG}██${BK}╔══╝${OG}    ██${BK}╔══╝      ╚═══${OG}██${BK}║   ${OG}██${BK}║  ${OG}██${BK}╝   ${OG}██${BK}║  ${OG}▄${BK}╗        ╚═══${OG}██${BK}║${OGF}   \\n"
printf "    ${OGF}▀████▀${BK}╝    ${OGF}▀████▀${BK}╗   ${OGF}▀████▀${BK}╗    ${OGF}▀████▀${BK}╝     ${OGF}▀███▀${BK}╝${OGF}     ▀███▀${BK}╝${OGF}       ▀████▀${BK}╝   ${BK} \\n"
printf "     ${BK}╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝      \\n${OGG}"
printf "${OGG}    ${OGG}▄████▄${BK}╗   ${OGG}▄█▄${BK}╗    ${OGG}▄███▄${BK}╗  ${OGG}██${BK}╗   ${OGG}██${BK}╗   ${OGG}▄█${BK}╗    ${OGG}▄█${BK}╗ ${OGG}▄█${BK}╗  ${OGG}▄█${BK}╗ ${OGG}▄█${BK}╗ ${OGG} ▄█${BK}╗ ${OGG}██▄${BK}╗  ${OGG}▄██${BK}╗   \\n"
printf "${GN}    ${GN}██${BK}╔═══╝  ${GN}██${BK}║${GN}██${BK}╗  ${GN}██${BK}╔═══╝  ${GN}▀██▄▄██▀${BK}╝   ${GN}██${BK}║    ${GN}██${BK}║ ${GN}█${BK}${GN}██▄${BK}╗${GN}██${BK}║${GN} ██${BK}║  ${GN}██${BK}║  ${GN}▀██▄██▀${BK}╝${GN}    \\n"
printf "${OGG}    ${GN}█████${BK}╗  ${GN}███▀███${BK}║  ${GN}▀███▄${BK}╗    ${GN}▀██▀${BK}╔╝    ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██▀████${BK}║ ${GN}██${BK}║  ${GN}██${BK}║   ${GN} ███${BK}║      \\n  "  
printf "  ${GN}██${BK}╔══╝  ${GN}██${BK}╔══${GN}${OGG}${GN}██${BK}║      ${GN}██${BK}║    ${GN}██${BK}║      ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██${BK}║ ${GN}███${BK}║ ${GN}██${BK}║  ${GN}██${BK}║  ${GN}▄██${BK}${GN}▀██${BK}${BK}╗     \\n"
printf "  ${WT}${OGG}   ${WT}▀███▀${BK}╝ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝     ${WT}██${BK}║      ${WT}▀████${BK}╗ ${WT}██${BK}║ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝  ${WT}██▀${BK}╝  ${WT}▀██${BK}╗   \\n   ${BK}"
printf "${OGG}  ${BK} ╚══╝  ${BK}╚═╝  ${BK}╚═╝   ${BK}╚═╝       ${BK}╚═╝       ${BK}╚═══╝ ${BK}╚═╝ ${BK}╚═╝  ${BK}╚═╝   ${BK}╚══╝   ${BK}╚═╝    ${BK}╚═╝   ${OGH}
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄\\n"
printf "${NC}${CY}"

#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
}

Banner_func

direnv_func() {
               read -p "DIRENV is not installed. Do you want me to install it? [Y/n] " choicedirenv
        choicedirenv=${choicedirenv:-Y}
                if [[ $choicedirenv =~ ^[Yy]$ ]]; then
                    printf "${GN}Continuing..." 
                    sleep 1
                    printf "This step may take a few minutes..."
                    sleep 1
                    printf "Please wait."
                    sudo apt update
                    sudo apt install -y direnv
                else
                   printf "${GN} Not Needed.  Continuing."
                
                fi
       check_directories_func
}

install_func() {

printf "${WT}   [*] ${CY}Dependencies satisfied. "; sleep 1
read -p "Do you want to install Easy Linux Loader? [Y/n] " choiceezlinux
        choiceezlinux=${choiceezlinux:-Y}
            if [[ $choiceezlinux =~ ^[Yy]$ ]]; then
              printf "${WT} [*] ${CY}Installation confirmed..."; sleep 1; printf "..Please wait.."
              sleep 1
            elif [[ $choiceezlinux =~ ^[Nn]$ ]]; then
              printf "${WT} [*] ${CY}Installation rejected..."; sleep 1; printf "..Please wait.."
              exit 0
            else
              printf "${RED} Exiting."
              exit 0
            fi
     get_files_func
}

check_directories_func() {
if [[ -d /opt/easy-linux ]]; then
    printf "  ${WT}[*] ${GN}/opt/easy-linux ${CY}directory found. Removing abd recloning repository."; sleep 1
    sudo rm -fr /opt/easy-linux
elif [[ ! -d /opt/easy-linux ]]; then
    sudo chown -vr 1000:1000 /opt
    printf "  ${WT} [*]  ${GN}/opt/easy-linux ${CY}directory not found. Cloning repo into that folder."; sleep 1
fi  
install_func

}
main() {
   clear
   Banner_func
   if command -v /usr/bin/direnv >/dev/null 2>&1; then
                printf "${GN}DIRENV is already installed\\n"
       check_directories_func
    else
    direnv_func
    fi


}
git_files_func() {

  printf "  ${WT} [*]  ${GN} Preparing to clone remote Git repo.${OG}"; sleep 1
  sudo git clone https://github.com/Beesoc/easy-linux.git /opt/easy-linux

cd /opt/easy-linux
sudo chown -vR 1000:1000 /opt/easy-linux
sudo chmod +x /opt/easy-linux/*.sh
sudo chmod +x /opt/easy-linux/install/*.sh
sudo chmod +x /opt/easy-linux/support/*.sh

sudo mv /opt/easy-linux/install/*.sh /opt/easy-linux/
sudo cp -f /opt/easy-linux/install/easy-linux.desktop /usr/share/applications/
}

main
source /opt/easy-linux/menu-master.sh
