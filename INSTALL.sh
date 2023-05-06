#!/bin/bash
# 
# Installer script for Beesoc's Easy Linux Loader.
#     define colors
# Version: 0.0.2
set -e

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

printf "${CY}\\n  Default install location is ${WT}/opt/easy-linux${CY}.\\n\\n"
read -p "Press enter to accept or enter your own path? [ /opt/easy-linux ] " scripts_dir
scripts_dir=${scripts_dir:-/opt/easy-linux}

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
      sudo rm -Rf ${scripts_dir}/install/     
  else 
       printf "     ${RED} Unknown error detected. Exiting.\\n"
       exit 1
  fi  

    sudo chown -Rf 1000:0 ${scripts_dir}
    sudo chown -Rf 1000:0 ${compiled_dir}

}

define_var_func() {
echo "export compiled_dir=${compiled_dir}" >> ${scripts_dir}/.envrc
echo "export scripts_dir=${scripts_dir}" >> ${scripts_dir}/.envrc
echo "export ORIGINAL_USER=$USER" >> ${scripts_dir}/.envrc


cd ${scripts_dir} && direnv allow 
}

install_func() { 
clear
    support-Banner_func
    sudo apt install -y bc direnv lm-sensors >/dev/null
define_var_func


read -p "$ORIGINAL_USER, do you want to install Easy Linux to ${scripts_dir}? [Y/n] " installchoice
installchoice=${installchoice:-Y}
if [[ $installchoice =~ ^[Yy]$ ]]; then
  printf "Continuing...\\n"
else
  printf "Exiting.\\n"
  exit 0
fi

          printf "${CY}Installing to ${WT}${scripts_dir}\\n" 

          sudo cp -Rf ${compiled_dir}/easy-linux/* ${scripts_dir}/
          sudo cp -f ${compiled_dir}/easy-linux/.envrc ${scripts_dir}
          sudo cp -f ${compiled_dir}/easy-linux/.envrc ${scripts_dir}/support
          sudo cp -f ${compiled_dir}/easy-linux/.shellcheckrc ${scripts_dir}
          sudo cp -f ${compiled_dir}/easy-linux/.shellcheckrc ${scripts_dir}/support
          sudo cp -f ${scripts_dir}/install ${scripts_dir}
          sudo chmod a+x ${scripts_dir}/*.sh

             cd ${scripts_dir} && direnv allow && sudo direnv allow
             cd ${scripts_dir}/support && direnv allow && sudo direnv allow
             cd ${scripts_dir}/install && direnv allow && sudo direnv allow
          source ${scripts_dir}/.envrc
  
              clear
              source ${scripts_dir}/support/support-Banner_func.sh
          sudo rm -f ${scripts_dir}/INSTALL.sh
          sudo rm -f ${scripts_dir}/SETUP.sh
          sudo chown -vR 1000:0 ${scripts_dir}  
          sudo chmod -R a+x ${scripts_dir}/*.sh
          sudo chmod -R a+x ${scripts_dir}/support/*.sh
            sudo cp -Rf ${scripts_dir}/menu-master.sh /usr/bin
            sudo cp -f ${scripts_dir}/install/easy-linux.desktop /usr/share/applications
            sudo touch ${scripts_dir}/support/adapter
            sudo rm -Rf ${compiled_dir}/easy-linux/.*
}

cleanup_func() {
  printf "${CY} - Please Wait while I cleanup some files used in the installation -${NC} \\n" 
  printf "${WT}..."; sleep 1; printf "...Almost done\\n" 

if [[ -d ${scripts_dir}/easy-linux/install ]]; then
  sudo rm -Rf ${scripts_dir}/easy-linux/install/
  sudo rmdir ${scripts_dir}/easy-linux/install/
fi
if [[ -d ${compiled_dir}/beesoc-menu ]]; then
  sudo rm -Rf ${compiled_dir}/beesoc-menu/
  sudo rmdir ${compiled_dir}/beesoc-menu/
fi
if [[ -d ${compiled_dir}/easy-linux ]]; then
  sudo rm -Rf ${compiled_dir}/easy-linux/
  sudo rmdir ${compiled_dir}/easy-linux/
fi
if [[ -f $HOME/Downloads/SETUP-easy-linux.sh ]]; then
  sudo rm -f $HOME/Downloads/SETUP-easy-linux.sh
fi
  sleep 1
  printf "...done.${CY}"

  clear
  support-Banner_func
  printf "   ${CY}Beesoc's Easy Linux Loader has been installed.\\n\\n" 
  printf "   Use the option on your ${WT}Apps menu ${CY}or enter [ ${WT}menu-master.sh${CY} ]\\n"
  printf "   from ${WT}any Terminal ${CY}to access. Thanks for using ${WT}Beesoc's Easy Linux Loader!\\n" 
  printf "\\n\\n  ${CY}Press ${WT}any ${CY}key to exit the installer.\\n  "
    read -r -n1 -s -t 300
  exit 0
}

main() {
clear
support-Banner_func
printf "\\n${OG}    Welcome to the Installer for Beesoc's Easy Linux    Press ${RED}[ctrl+c] ${OG}to cancel\\n${CY}${NC}\\n" 

read -p "Do you want to install Beesoc's Easy Linux Loader? [Y/n] " install
install=${install:-Y}
if [[ $install =~ ^[Yy]$ ]]; then
  echo "Loading...Please Wait..."
else
  echo "Exiting."
  exit 0
fi

folder_exists_func
install_func  
}

main
cd ${scripts_dir} || exit
direnv allow && sudo direnv allow
cleanup_func
