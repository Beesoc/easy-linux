#!/bin/bash
# 
# Installer script for Beesoc's Easy Linux Loader.
#     define colors
BK='\e[0;44;30m'
RED='\e[1;31m'
GN='\e[1;32m'
YW='\e[1;33m'
BL='\e[1;34m'
PL='\e[1;35m'
CY='\e[1;36m'
WT='\e[1;37m'
WTU='\e[4;37m'
OG='\e[1;93m'
OGU='\e[1;93m'
OGF='\e[0;33;44m'
OGG='\e[0;32;44m'
OGH='\e[0;30;44m'
UK='\e[0;38m'
BG='\e[0;44m'
NC='\e[0m'
#
scripts_dir=/opt/easy-linux-loader
source .envrc
#printf "${BG}"

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

printf "${GN}┌──(${CY}$USER${prompt_symbol}$HOST${GN})-[${YW}${PWD}${GN}]\\n"
printf "${GN}└─"${CY}"> ${CY}\\n"

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
    ██${BK}╔══╝  ${GN}██${BK}║  ${GN}██${BK}║   ╚══${GN}██${BK}║   ${GN}██${BK}╔╝     ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██${BK}║${GN}▀███${BK}║ ${GN}██${BK}║  ${GN}██${BK}║  ${GN}▄██▀██▄${BK}╗    ${WT}
    ▀████▀${BK}╝ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝    ${WT}██${BK}║      ${WT}▀████${BK}╗ ${WT}██${BK}║ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝  ${WT}██▀${BK}╝  ${WT}▀██${BK}╗   ${BK}
     ╚═══╝  ╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═══╝ ╚═╝ ╚═╝  ╚═╝   ╚═╝    ╚═╝    ╚═╝   ${OGH}
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄\\n"
printf "${NC}"
#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
  #
}

folder_exists_func() {
  clear
  Banner_func
if [[ ! -d ${scripts_dir} ]]; then  
    sudo mkdir ${scripts_dir}
elif [[ -d ${scripts_dir} ]]; then  
  printf "${CY}     Installation directory, ${WT}${scripts_dir}${CY}, already exists. ${OG}Overwrite?  ${WT}\\n "
    printf "${NC}\\n     NOTE: ${CY}If you have ${WT}NOT manually customized ${CY}any scripts, you ahould ${WT}always \\n"
    printf "     answer yes ${CY}to this question.\\n\\n"
    printf "${CY}    ---->${OG}"
else
    printf "      Invalid Selection\\n"
fi
}

install_func() { 
clear
        Banner_func
        Prompt_func
        printf "  Default install loation is ${WT}${scripts_dir} "
    read -p "   Should I install to the default location? [Y/N]  " install
        if [[ ${install} == "n" ]] || [[ ${install} == "N" ]]; then
            printf "${RED}     You chose not to install. Quiting application"
            exit 1
        elif [[ ${install} == "y" ]] || [[ ${install} == "Y" ]]; then
# add zip files to archive with:
#  sudo zip -rvq -T -9 INSTALL.zip *.sh  

#            if [[ ! command -v unzip &> /dev/null ]]; then
#                printf "Unzip could not be found...Installing...\\n"
#                sudo apt install -y zip unzip
 
            command -v unzip >/dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed.  Installing."; sudo apt install -y unzip; }
   
#            elif [[ ! command -v unzip &> /dev/null ]]; then
#                printf "Unzip found...Continuing...\\n"
#            fi

           printf "${CY}Unzipping archives\\n"
            sudo unzip -o *.zip
              sudo cp *.sh ${scripts_dir}
              sudo chmod a+x *.sh
        else
            printf "     Invalid selection\\n"
        fi
}

main() {
clear
Banner_func
printf "\\n${OG}                 Welcome to the Installer for Beesoc's Easy Linux.                   ${CY}${NC}\\n" 
printf "\\n${CY}Press ${WT}any ${CY}key to continue.                                 Press ${RED}[ctrl+c] ${CY}to cancel\\n"
sudo apt install -y direnv > /dev/null
#printf "${WT}\\n   -->"
printf "${WT} \\n  ---->"
  read -r -n1 -s -t 60
folder_exists_func
install_func  
sudo cp README.md ${scripts_dir}/
sudo cp *.desktop /usr/share/applications/
sudo chmod a+x ./*.sh
}

main
direnv allow
