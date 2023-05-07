#!/bin/bash
# Installer script for Beesoc's Easy Linux Loader.
# Version: 0.0.2
set -euo pipefail

# Install prereq, DIRENV
           if command -v /usr/bin/direnv >/dev/null 2>&1; then
                printf "${GN}DIRENV is already installed\\n"
           else
                printf "${YW}DIRENV is not installed. Installing\\n"
                direnvinstall=$(curl -sfL https://direnv.net/install.sh | bash)
	        source $direnvinstall
           fi

chmod a+x *.sh
chmod a+x install/*.sh
chmod a+x support/*.sh

if [[ !-d $compiled_dir ]]; then
    mkdir $compiled_dir
elif [[ -d $compiled_dir ]]; then
		if [[ -d $compiled_dir/tmp ]]; then
			  sudo rm -rf $compiled_dir/tmp
			  sudo mkdir $compiled_dir/tmp
		elif [[ !-d $compiled_dir/tmp ]]; then
			 sudo mkdir $compiled_dir/tmp
			 sudo chown -vR 1000:0 $compiled_dir/tmp
			 printf "${GN}  Continuing...."
		fi
fi

cd $compiled_dir/tmp

echo "#/bin/bash
# Temp .envrc
export CY='\e[1;36m'
export WT='\e[1;37m'
export RED='\e[1;31m'
export OG='\e[1;93m'
export NC='\e[0m'

scripts_dir=/opt/easy-linux" > $compiled_dir/tmp/.envrc
cd $compiled_dir/tmp && direnv allow
source $compiled_dir/tmp/.envrc

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
printf "\\n${WT}    Welcome to the Installer for Beesoc\'s Easy Linux    "
printf "${CY}Press ${RED}[ctrl+c] ${CY}to cancel${CY}${NC}\\n" 
printf "\\n      ${OG}This installer will create the necessary folders and clone the official\\n"
printf "      repo for ${WT}Beesoc\'s Easy Linux ${OG}for installation. You will need a ${WT}Github username\\n"
printf "      username ${WT}and ${WT}fine-grained access token ${CY}to continue.\\n"
printf "\\n  ${WT}If you need to create a fine grained personal access token, see here for instructions:${WT}\\n" 
printf "${OG}https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-fine-grained-personal-access-token\\n"
printf "\\n"
printf "${WT}\\n    For more info on Github\'s Personal Access Token see:\\n" 
printf "${OG}https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token${GN}\\n"

read -p "Would you like me to automagically clone the repo for installation? [Y/n] " installdec
installdec=${installdec:-Y}
if [[ $installdec =~ ^[Yy]$ ]]; then
  printf "${OG}    Continuing...\\n"
else
  printf "${RED}    Exiting.\\n"
  exit 0
fi

     if [[ ! -d ${compiled_dir} ]]; then
       printf "${CY}  ${compiled_dir} directory not found. Creating folder and ${WT}cloning Github${CY} repo.\\n"
       mkdir "${compiled_dir}"
     fi
     if [[ ! -d "${compiled_dir}/easy-linux" ]]; then
           printf "${CY}  ${compiled_dir}/easy-linux directory not found.\\n"
           printf "${CY}  Creating folder and ${WT}cloning Github ${CY}repo.\\n"
           mkdir "${compiled_dir}"/easy-linux 
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

    cd "${compiled_dir}" || exit
    git clone https://github.com/Beesoc/easy-linux.git
    sudo rm -f $compiled_dir/tmp/.envrc
    source "$HOME"/compiled/easy-linux/INSTALL.sh
