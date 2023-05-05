#!/bin/bash
# 
# Installer script for Beesoc's Easy Linux Loader.
#          ADMIN NOTE:  add zip files to archive with:
#          zip -rv INSTALL.zip ./support/ ./install/  
#     define colors
# Version: 0.0.2
set -e

scripts_dir="/opt/easy-linux"
compiled_dir=$HOME/compiled

RED='\e[1;31m'
CY='\e[1;36m'
WT='\e[1;37m'

#printf "${BG}"

support-Banner_func() {
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

folder_exists_func() {
  clear
  support-Banner_func

if [[ ! -d "${scripts_dir}" ]]; then  
    printf "  ${CY}${scripts_dir} not found.\\n${CY}    Please Wait, creating ${WT}${scripts_dir} ${CY}directory"; sleep 1 
    printf "${WT}.."; sleep 1; printf "..\\n"; sleep 1
    sudo mkdir ${scripts_dir}
elif [[ -d ${scripts_dir} ]]; then 
    printf "${scripts_dir} found. Continuing.\\n"
else 
    printf "     ${RED} Unknown error detected. Exiting.\\n"
    exit 1
fi
  sudo chown -Rf 1000:0 ${scripts_dir}

  if [[ ! -d ${scripts_dir}/tmp ]]; then  
        printf "  ${CY}${scripts_dir}/tmp not found.\\n${CY}    Please Wait, creating ${WT}${scripts_dir}/tmp ${CY}directory"; sleep 1 
        printf "${WT}.."; sleep 1; printf "..\\n"; sleep 1
        sudo mkdir ${scripts_dir}/tmp
  elif [[ -d ${scripts_dir}/tmp ]]; then 
      printf "${scripts_dir}/tmp found. Continuing.\\n"
      sudo chown -Rf 1000:0 ${scripts_dir}/tmp
      sudo rm -Rf ${scripts_dir}/tmp/
      sudo mkdir ${scripts_dir}/tmp
  else 
       printf "     ${RED} Unknown error detected. Exiting.\\n"
       exit 1
  fi

if [[ ! -d ${scripts_dir}/support ]]; then  
        printf "  ${CY}${scripts_dir}/support not found.\\n${CY}    Please Wait, creating ${WT}${scripts_dir}/support ${CY}directory"; sleep 1 
        printf "${WT}.."; sleep 1; printf "..\\n"; sleep 1
        sudo mkdir ${scripts_dir}/support
  elif [[ -d ${scripts_dir}/support ]]; then 
      printf "${scripts_dir}/support found. Continuing.\\n"
      sudo chown -Rf 1000:0 ${scripts_dir}/support
      sudo rm -Rf ${scripts_dir}/support/
      sudo mkdir ${scripts_dir}/support
  else 
       printf "     ${RED} Unknown error detected. Exiting.\\n"
       exit 1
  fi  
  if [[ ! -d ${scripts_dir}/install ]]; then  
        printf "  ${CY}${scripts_dir}/install not found.\\n${CY}    Please Wait, creating ${WT}${scripts_dir}/install ${CY}directory"; sleep 1 
        printf "${WT}.."; sleep 1; printf "..\\n"; sleep 1
        sudo mkdir "${scripts_dir}/install"
  elif [[ -d ${scripts_dir}/install ]]; then 
      printf "${scripts_dir}/install found. Continuing.\\n"
      sudo chown -Rf 1000:0 ${scripts_dir}/install
  else 
       printf "     ${RED} Unknown error detected. Exiting.\\n"
       exit 1
  fi  

    sudo chown -Rf 1000:0 ${scripts_dir}
    sudo chown -Rf 1000:0 ${compiled_dir}

}

install_func() { 
clear
    support-Banner_func
    sudo apt install -y bc zip direnv lm-sensors >/dev/null
    printf "  ${CY}Press ${WT}any ${CY}key to install ${WT}Beesoc's Easy Linux Loader${CY}...or cancel with ${RED}Ctrl C${WT}\\n"
#    printf " ${WT}    ----->"
    read -r -n1 -s -t 60

          printf "${CY}Unzipping files into ${WT}'${scripts_dir}/tmp' ${CY}and then installing to ${WT}${scripts_dir}\\n"
          sudo cp -Rf ${compiled_dir}/easy-linux/* ${scripts_dir}/tmp/ 
          sudo cp -Rf ${compiled_dir}/easy-linux/.envrc ${scripts_dir}
            cd ${scripts_dir} && direnv allow && sudo direnv allow
          sudo cp -Rf ${compiled_dir}/easy-linux/.envrc ${scripts_dir}/support
            cd ${scripts_dir}/support && direnv allow && sudo direnv allow
          sudo cp -Rf ${compiled_dir}/easy-linux/.envrc ${scripts_dir}/install
            cd ${scripts_dir}/install && direnv allow && sudo direnv allow
          sudo cp -Rf ${compiled_dir}/easy-linux/.shellcheckrc ${scripts_dir}/ 

          cd ${scripts_dir}/tmp || exit
          sudo unzip -uqo *.zip
          sudo cp -f ${scripts_dir}/tmp/install/easy-linux.desktop /usr/share/applications/
          sudo cp -Rf ./* ${scripts_dir}

          sudo mv ${scripts_dir}/tmp/support/* ${scripts_dir}/support
          sudo mv ${scripts_dir}/tmp/install/* ${scripts_dir}
          sudo rm -Rf ${scripts_dir}/install/
          sudo rm -Rf ${scripts_dir}/tmp/
          sudo rm -f ${scripts_dir}/INSTALL.sh
          sudo rm -f ${scripts_dir}/SETUP.sh
          sudo chown -vR 1000:0 ${scripts_dir}  
          sudo chmod -R a+x ${scripts_dir}/*.sh
            sudo cp -Rf ${scripts_dir}/menu-master.sh /usr/bin
            sudo touch ${scripts_dir}/support/adapter
            sudo rm -Rf ${compiled_dir}/easy-linux/.*
        cd ${scripts_dir} && direnv allow && sudo direnv allow
}

cleanup_func() {
  printf "${CY} - Please Wait while I cleanup some files used in the installation -${NC} \\n" 
  printf "${WT}..."; sleep 1; printf "...Almost done\\n" 

if [[ -d ${scripts_dir}/easy-linux/tmp ]]; then
  sudo rm -f ${scripts_dir}/easy-linux/tmp/*
  sudo rmdir ${scripts_dir}/easy-linux/tmp/
fi
if [[ -d ${scripts_dir}/easy-linux/install ]]; then
  sudo rm -f ${scripts_dir}/easy-linux/install/*
  sudo rmdir ${scripts_dir}/easy-linux/install/
fi
if [[ -d ${compiled_dir}/beesoc-menu ]]; then
  sudo rm -f ${compiled_dir}/beesoc-menu/*
  sudo rmdir ${compiled_dir}/beesoc-menu/
fi
if [[ -d ${compiled_dir}/easy-linux ]]; then
  sudo rm -f ${compiled_dir}/easy-linux/*
  sudo rmdir ${compiled_dir}/easy-linux/
fi
if [[ -f ${compiled_dir}/SETUP-easy-linux.sh ]]; then
  sudo rm -f ${compiled_dir}/SETUP-easy-linux.sh
fi
  sleep 1
  printf "...done.${CY}"

  clear
  support-Banner_func
  printf "   ${CY}Beesoc's Easy Linux Loader has been installed.\\n\\n" 
  printf "   Use the option on your ${WT}Apps menu ${CY}or enter [ ${WT}menu-master.sh${CY} ]\\n"
  printf "   from ${WT}any Terminal ${CY}to access. Thanks for using ${WT}Beesoc's Easy Linux Loader!\\n" 
  printf "\\n\\n  ${CY}Press ${WT}any ${CY}key to exit the installer.\\n  "
    read -r -n1 -s -t 60
  exit 1
}

main() {
clear
support-Banner_func
#printf "\\n${OG}                 Welcome to the Installer for Beesoc's Easy Linux.                   ${CY}${NC}\\n" 
printf "\\n${CY}Press ${WT}any ${CY}key to continue.                              Press ${RED}[ctrl+c] ${CY}to cancel\\n"
#printf "${WT}\\n    ---->"
printf "${WT} \\n"
  read -r -n1 -s -t 60

folder_exists_func
install_func  
}

main
cd ${scripts_dir} || exit
direnv allow && sudo direnv allow
cleanup_func
exit 1
