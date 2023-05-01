#!/bin/bash
# 
# Installer script for Beesoc's Easy Linux Loader.
#          ADMIN NOTE:  add zip files to archive with:
#          zip -rv INSTALL.zip ./support/ ./install/  
#     define colors
# Version: 0.0.2
set -e
RED='\e[1;31m'
CY='\e[1;36m'
WT='\e[1;37m'

#printf "${BG}"
scripts_dir="/opt/easy-linux"
compiled_dir=$HOME/compiled

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
    printf "  ${CY}$scripts_dir not found.\\n${CY}    Please Wait, creating ${scripts_dir} dir."; sleep 1 
    printf "${WT}.."; sleep 1; printf ".."; sleep 1
    sudo mkdir "${scripts_dir}"
elif [[ -d "${scripts_dir}" ]]; then 
    printf "${scripts_dir} found. Continuing."
else 
    printf "     ${RED} Unknown error detected. Exiting."
    exit 1
fi
  sudo chown -Rf 1000:0 $scripts_dir

  if [[ ! -d "${scripts_dir}/tmp" ]]; then  
        printf "  ${CY}${scripts_dir}/tmp not found.\\n${CY}    Please Wait, creating ${scripts_dir} dir."; sleep 1 
        printf "${WT}.."; sleep 1; printf ".."; sleep 1
        sudo mkdir "${scripts_dir}/tmp"
  elif [[ -d "${scripts_dir}/tmp" ]]; then 
      printf "${scripts_dir}/tmp found. Continuing."
      sudo chown -Rf 1000:0 ${scripts_dir}/tmp
      sudo rm -Rf ${scripts_dir}/tmp/
      sudo mkdir ${scripts_dir}/tmp
  else 
       printf "     ${RED} Unknown error detected. Exiting."
       exit 1
  fi

if [[ ! -d "${scripts_dir}/support" ]]; then  
        printf "  ${CY}${scripts_dir}/support not found.\\n${CY}    Please Wait, creating ${scripts_dir}/support dir."; sleep 1 
        printf "${WT}.."; sleep 1; printf ".."; sleep 1
        sudo mkdir "${scripts_dir}/support"
  elif [[ -d "${scripts_dir}/support" ]]; then 
      printf "${scripts_dir}/support found. Continuing."
      sudo chown -Rf 1000:0 ${scripts_dir}/support
      sudo rm ${scripts_dir}/support/*
      sudo rmdir -f ${scripts_dir}/support
      sudo mkdir ${scripts_dir}/support
  else 
       printf "     ${RED} Unknown error detected. Exiting."
       exit 1
  fi  
  if [[ ! -d "${scripts_dir}/install" ]]; then  
        printf "  ${CY}${scripts_dir}/install not found.\\n${CY}    Please Wait, creating ${scripts_dir}/install dir."; sleep 1 
        printf "${WT}.."; sleep 1; printf ".."; sleep 1
        sudo mkdir "${scripts_dir}/install"
  elif [[ -d "${scripts_dir}/install" ]]; then 
      printf "${scripts_dir}/install found. Continuing."
      sudo chown -Rf 1000:0 ${scripts_dir}/install
      sudo rm ${scripts_dir}/install/*
      sudo rmdir -f ${scripts_dir}/install
      sudo mkdir ${scripts_dir}/install
  else 
       printf "     ${RED} Unknown error detected. Exiting."
       exit 1
  fi  

    sudo chown -Rf 1000:0 ${scripts_dir}
    sudo chown -Rf 1000:0 ${compiled_dir}

}

install_func() { 
clear
    support-Banner_func
    sudo apt install -y bc zip direnv lm-sensors >/dev/null
          printf " ${WT} "
    read -pr "   Should I install to default location? [Y/N]  " install
        if [[ ${install} == "n" ]] || [[ ${install} == "N" ]]; then
            printf "${RED}     You chose not to install. Quiting application"
            exit 1
        elif [[ ${install} == "y" ]] || [[ ${install} == "Y" ]]; then
          printf "${CY}Unzipping files into ${WT}'${scripts_dir}/tmp' ${CY}and then installing to ${WT}${scripts_dir}\\n"
          sudo mv -f ${compiled_dir}*.zip $scripts_dir/tmp/ 
          cd ${scripts_dir}/tmp || exit
          sudo unzip -uqo *.zip
          sudo cp -rf ./*.sh ${scripts_dir}
          
          sudo mv $scripts_dir/tmp/support/* ${scripts_dir}/support
          sudo mv ${scripts_dir}/tmp/install/* ${scripts_dir}
          sudo cp $compiled_dir/* $scripts_dir
          sudo cp ${compiled_dir}/.envrc $scripts_dir
            cd ${scripts_dir} || exit && direnv allow && sudo direnv allow
          sudo cp ${compiled_dir}/.envrc $scripts_dir/support
            cd ${scripts_dir}/support || exit && direnv allow && sudo direnv allow
          sudo cp ${compiled_dir}/.envrc ${scripts_dir}/install
            cd ${scripts_dir}/install || exit && direnv allow && sudo direnv allow
          sudo cp ${compiled_dir}/.shellcheckrc ${scripts_dir}/ 
          sudo chown -vR 1000:0 ${scripts_dir}
          sudo chmod -R a+x ${scripts_dir}
            sudo cp ${scripts_dir}/install/menu-master.sh /usr/bin
            sudo mv install/easy-linux.desktop /usr/share/applications/easy-linux.desktop
            sudo cp .envrc $scripts_dir && direnv allow && sudo direnv allow
        sudo touch ${scripts_dir}support/adapter
        cd $scripts_dir || exit && direnv allow && sudo direnv allow
        else
            printf "     Invalid selection\\n"
        fi
}

cleanup_func() {
  printf " - Please Wait while I cleanup some files used in the installation - \\n" 
  printf "${WT}..."; slept 1; printf "...Almost done\\n" 
  sudo rm -f ${scripts_dir}tmp/*.*
  sudo rmdir -f tmp/
  rm -f ${compiled_dir}/beesoc-menu/*
  sudo rmdir -f ${compiled_dir}/beesoc-menu/
  printf "...done.${CY}"
  clear
  support-Banner_func
  printf "   ${CY}Beesoc's Easy Linux Loader has been installed.\\n\\n" 
  printf "   Use the option on your ${WT}Apps menu ${CT}or enter [ ${WT}menu-master.sh${CT} ]\\n"
  printf "   from ${WT}any Terminal ${CY} to access. Thanks for using ${WT}Beesoc's Easy Loader\\n" 
  printf "\\n\\n  ${CY}Press ${WT}any ${CY}key to exit the installer.\\n  "
    read -r -n1 -s -t 60
  exit 1
}

main() {
clear
support-Banner_func
printf "\\n${OG}                 Welcome to the Installer for Beesoc's Easy Linux.                   ${CY}${NC}\\n" 
printf "\\n${CY}Press ${WT}any ${CY}key to continue.                                 Press ${RED}[ctrl+c] ${CY}to cancel\\n"
#printf "${WT}\\n    ---->"
printf "${WT} \\n"
  read -r -n1 -s -t 60

folder_exists_func
install_func  
}

main
cleanup_func
