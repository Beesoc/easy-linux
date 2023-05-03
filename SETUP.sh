#!/bin/bash
# Installer script for Beesoc's Easy Linux Loader.
#          ADMIN NOTE:  add zip files to archive with:
#          zip -r INSTALL.zip ./support/ ./install/
# Version: 0.0.2
set -e

scripts_dir=/opt/easy-linux
compiled_dir=$HOME/compiled

echo "#!/bin/bash
# Cleanup script
# Version: 0.0.2
set -e

scripts_dir=/opt/easy-linux
compiled_dir=$HOME/compiled

cleanup_func() {
if [[ ! -d ${scripts_dir} ]]; then  
    return
elif [[ -d ${scripts_dir} ]]; then 
    sudo rm -RF ${scripts_dir}
else 
    return
fi
if [[ ! -d ${compiled_dir}/easy-linux ]]; then  
    return
elif [[ -d ${compiled_dir}/easy-linux ]]; then 
    sudo rm -RF ${compiled_dir}/easy-linux
else 
    return
fi
}

cleanup_func
exit" > .cleanup.sh
sudo chmod a+x ./.cleanup.sh

echo "#!/bin/bash
sudo bash ./.cleanup.sh
exit" > .cleanup2.sh

sudo chmod a+x ./.cleanup2.sh

trap ./.cleanup2.sh EXIT

# trap ./.cleanup.sh EXIT
CY='\e[1;36m'
WT='\e[1;37m'
RED='\e[1;31m'
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
printf "\\n${WT}                 Welcome to the Installer for Beesoc's Easy Linux.                   ${CY}${NC}\\n" 
printf "\\n\\n\\n        ${CY}This installer will create the necessary folders and then clone\\n"
printf "        the official repo for ${WT}Beesoc's Easy Linux ${CY}for installation. You will \\n"
printf "        need a ${WT}Github username ${CY}and ${WT}fine-grained access token ${CY}to continue.\\n"
printf "\\n${WT}        For more info on Github's Personal Access Token see \\n"
printf "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token.\\n"
printf "\\n${CY}Press ${WT}any ${CY}key to continue.                            Press ${RED}[ctrl+c] ${CY}to cancel\\n"
#printf "${WT}\\n    ---->"
printf "${WT} \\n"
  read -r -n1 -s -t 60
  if [[ -d ${compiled_dir} ]]; then
    cd ${compiled_dir}/ || exit
    if [[ -d "${compiled_dir}/easy-linux" ]]; then  
       printf "  ${CY}Existing Github clone for Beesoc's Easy Linux found.\\n${CY}"
       printf "       Please Wait, removing tmp clone and cloning Github repo to ${WT}${scripts_dir}.\\n"; sleep 1 
       printf "${WT}.."
       sudo rm -Rf ${compiled_dir}/easy-linux  
       sleep 1; printf ".."; sleep 1
    elif [[ ! -d "${compiled_dir}/easy-linux" ]]; then
       printf "  ${CY}Easy-Linux directory not found.  Creating folder and ${WT}cloning Github${CY} repo.\\n"     
    fi
  elif [[ ! -d ${compiled_dir} ]]; then   
    printf "   ${compiled_dir} not found.  Creating folder..."  
    mkdir "${compiled_dir}"
  else
    printf "$RED   Unknown error. Do you have rights to create $HOME/compiled?"
    exit 1
  fi  
    cd ${compiled_dir} || exit
    git clone https://github.com/Beesoc/easy-linux.git
    cd easy-linux || exit
    sudo chmod a+x ./.cleanup.sh
    sudo chmod a+x ./.cleanup2.sh
    sudo chmod a+x ./INSTALL.sh
    bash ./INSTALL.sh