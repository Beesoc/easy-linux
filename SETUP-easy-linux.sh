#!/bin/bash
# Installer script for Beesoc's Easy Linux Loader.
#          ADMIN NOTE:  add zip files to archive with:
#          zip -r INSTALL.zip ./support/ ./install/ ./archive/
# Version: 0.0.2
set -e

compiled_dir=$HOME/compiled

#sudo chmod a+x ${compiled_dir}/easy-linux/INSTALL.sh
    
CY='\e[1;36m'
WT='\e[1;37m'
RED='\e[1;31m'
OG='\e[1;93m'
NC='\e[0m'

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
printf "\\n${WT}                 Welcome to the Installer for Beesoc\'s Easy Linux.         Press ${RED}[ctrl+c] ${CY}to cancel${CY}${NC}\\n" 
printf "\\n      ${CY}This installer will create the necessary folders and clone the official\\n"
printf "      repo for ${WT}Beesoc\'s Easy Linux ${CY}for installation. You will need a ${WT}Github username\\n"
printf "      username ${CY}and ${WT}fine-grained access token ${CY}to continue.\\n"
printf "\\n  ${OG}If you need to create a fine grained personal access token, see here for instructions:${GN}\\n" 
printf "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-fine-grained-personal-access-token\\n"
printf "\\n"
printf "${WT}\\n    For more info on Github\'s Personal Access Token see:\\n" 
printf "${OG}https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token\\n"

read -p "Would you like to continue with the installation? [Y/n] " installdec
installdec=${install:-Y}
if [[ $installdec =~ ^[Yy]$ ]]; then
  printf "Continuing...\\n"
else
  printf "Exiting.\\n"
  exit 0
fi

     if [[ ! -d ${compiled_dir} ]]; then
       printf "${CY}  ${compiled_dir} directory not found.  Creating folder and ${WT}cloning Github${CY} repo.\\n"
       mkdir ${compiled_dir}
     fi
     if [[ ! -d "${compiled_dir}/easy-linux" ]]; then
           printf "${CY}  ${compiled_dir}/easy-linux directory not found.\\n"
           printf "${CY}  Creating folder and ${WT}cloning Github ${CY}repo.\\n"
           mkdir ${compiled_dir}/easy-linux 
     fi
     if [[ -d "${compiled_dir}/easy-linux" ]]; then  
       printf "  ${CY}Existing Github clone for Beesoc\'s Easy Linux found.\\n${CY}"
       printf "       Please Wait, recloning Github repo.\\n" 
       sleep 1 
       printf "${WT}..."
       sudo rm -Rf "${compiled_dir}/easy-linux"  
       sleep 1
       printf "${WT}..."
       sleep 1
     fi  
       cd ${compiled_dir} || exit
       
git clone https://github.com/Beesoc/easy-linux.git
    source $HOME/compiled/easy-linux/INSTALL.sh
