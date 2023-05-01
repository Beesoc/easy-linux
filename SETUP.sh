#!/bin/bash
# Installer script for Beesoc's Easy Linux Loader.
#          ADMIN NOTE:  add zip files to archive with:
#          zip -r INSTALL.zip ./support/ ./install/
# Version: 0.0.2
set -e
CY='\e[1;36m'
WT='\e[1;37m'
RED='\e[1;31m'
NC='\e[0m'
scripts_dir="/opt/easy-linux"
install_compiled="$HOME/compiled"
clear
Banner_func() {
  printf "${WT}\\n
-------------------------------------------------------------------------------${CY}
  ▄████▄╗    ▄████▄╗   ▄████▄╗    ▄████▄╗     ▄███▄╗     ▄███▄╗  ██╗  ▄████▄╗  
  ██═══██╝   ██╔═══╝   ██╔═══╝   ██╔════╝    ██╔══██╗   ██╔══▀╝   ▀╝ ██╔════╝  
  ██████╝    █████╗    █████╗     ▀████▄╗    ██║  ██║   ██║           ▀████▄╗  
  ██═══██    ██╔══╝    ██╔══╝      ╚═══██║   ██║  ██╝   ██║  ▄╗        ╚═══██║ 
  ▀████▀╝    ▀████▀╗   ▀████▀╗    ▀████▀╝     ▀███▀╝     ▀███▀╝       ▀████▀╝  
   ╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝
  ▄████▄╗   ▄█▄╗    ▄███▄╗ █▄╗   ▄█╗   ▄█╗    ▄█╗ ▄█╗  █▄╗ ▄█╗  ▄█╗ ██▄╗  ▄██╗ 
  ██╔═══╝  ██║██╗  ██╔═══╝  ██╗ ██╔╝   ██║    ██║ ██▄╗ ██║ ██║  ██║  ▀██▄██▀╝  
  █████╗  ███▀███╗  ▀███▄╗   ████╔╝    ██║    ██║ ████▄██║ ██║  ██║    ███║    
  ██╔══╝  ██║  ██║   ╚══██║   ██╔╝     ██║    ██║ ██║▀███║ ██║  ██║  ▄██▀██▄╗  
  ▀████▀╝ ██║  ██║  ▀███▀╝    ██║      ▀████╗ ██║ ██║  ██║  ▀███▀╝  ██▀╝  ▀██╗ 
   ╚═══╝  ╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═══╝ ╚═╝ ╚═╝  ╚═╝   ╚═╝    ╚═╝    ╚═╝ ${WT}
------------------------------------------------------------------------------- \\n"
  #
#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
}
Banner_func
printf "\\n${CY}                 Welcome to the Installer for Beesoc's Easy Linux.                   ${CY}${NC}\\n" 
printf "\\n${CY}Press ${WT}any ${CY}key to continue.                            Press ${RED}[ctrl+c] ${CY}to cancel\\n"
#printf "${WT}\\n    ---->"
printf "${WT} \\n"
  read -r -n1 -s -t 60
  if [[ -d "$HOME/compiled" ]]; then
    cd $HOME/compiled/ || exit
    if [[ -d "${install_compiled}/easy-linux" ]]; then  
       printf "  ${CY}Existing Github clone for Beesoc's Easy Linux found.\\n${CY}"
       printf "       Please Wait, removing tmp clone and cloning Github repo to ${WT}${scripts_dir}.\\n"; sleep 1 
       printf "${WT}.."
       sudo rm -Rf $HOME/compiled/easy-linux  
       sleep 1; printf ".."; sleep 1
    elif [[ ! -d "${install_compiled}/easy-linux" ]]; then
       printf "  ${CY}Easy-Linux directory not found.  Creating folder and ${WT}cloning Github${CY} repo.\\n"     
    fi
  elif [[ ! -d "$HOME/compiled" ]]; then   
    printf "   $HOME/compiled not found.  Creating folder..."  
    mkdir "$HOME/compiled"
  else
    printf "$RED   Unknown error. Do you have rights to create $HOME/compiled?"
    exit 1
  fi  
    cd $HOME/compiled || exit
    git clone https://github.com/Beesoc/beesoc-menu.git
    cd beesoc-menu || exit
    sudo chmod a+x ./INSTALL.sh
    bash ./INSTALL.sh
