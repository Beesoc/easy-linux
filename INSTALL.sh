#!/bin/bash
# 
# Installer script for Beesoc's Easy Linux Loader.
#     define colors
RED='\e[1;31m'
CY='\e[1;36m'
WT='\e[1;37m'

#printf "${BG}"
scripts_dir="/opt/easy-linux"

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

folder_exists_func() {
  clear
  Banner_func.sh

if [[ ! -d "${scripts_dir}/tmp" ]]; then  
    printf "  ${CY}$scripts_dir/tmp not found.\\n${CY}    Please Wait, creating tmp dir, '${WT}${scripts_dir}/tmp'${CY}."; sleep 1 
    printf "${WT}.."; sleep 1; printf ".."; sleep 1
    sudo mkdir "${scripts_dir}"
    sudo mkdir ${scripts_dir}/tmp
    sudo chown -Rf 1000:0 "${scripts_dir}"
    sleep 1
      if [[ -d "${scripts_dir}/tmp" ]]; then  
          printf "${CY}done..\\n"
      else 
          printf "${RED} An error has occurred. Exiting tool."
          exit 1
      fi

elif [[ -d ${scripts_dir}/tmp ]]; then  
  printf "${CY}     Please Wait, checking tmp folder permissions, ${WT}${scripts_dir}/tmp ${CY}."; sleep 1 
  sudo rm -rf ${scripts_dir}/tmp -y
  sudo rm -rf ${scripts_dir}
  sudo mkdir ${scripts_dir}
  sudo mkdir ${scripts_dir}/tmp
  printf "${WT}.."; sleep 1; printf ".."; sleep 1 
    sudo chown -Rf 1000:0 "${scripts_dir}"
    sleep 1
      if [[ -d "${scripts_dir}/tmp" ]]; then  
          printf "${CY}done..\\n"
      else 
          printf "${RED} An error has occurred. Exiting tool."
          exit 1
      fi

else 
    printf "${RED} An error has occurred.  Exiting Tool."
    exit 1
fi

}

install_func() { 
clear
    Banner_func
    sudo apt install -y bc cat zip direnv lm-sensors >/dev/null
          printf " ${WT} "
    read -pr "   Should I overwrite and install to default location? [Y/N]  " install
        if [[ ${install} == "n" ]] || [[ ${install} == "N" ]]; then
            printf "${RED}     You chose not to install. Quiting application"
            exit 1
        elif [[ ${install} == "y" ]] || [[ ${install} == "Y" ]]; then
#          ADMIN NOTE:  add zip files to archive with:
#          sudo zip -rvq -T -9 INSTALL.zip *.sh  
folder_exists_func
#            if [[ ! command -v unzip &>  /dev/null ]]; then
#                printf Prompt_func() {


#printf "${YW}Unzip could not be found...\\nAttempting to Install ${WT}unzip${CY}...Please wait...\\n${WT}\\n"
#  sudo apt install -y zip unzip > /dev/null

    printf "${CY}Unzipping files into ${WT}'${scripts_dir}/tmp' ${CY}and then installing to ${WT}${scripts_dir}\\n"
      sudo mv -f *.zip tmp/ 
      sudo unzip -uqo tmp/*.zip
      sudo cp -rf tmp/*.sh ${scripts_dir}
        sudo chmod -R a+x ${scripts_dir}/*.sh
              sudo chown -vR 1000:0 ${scripts_dir}
        sudo cp ${scripts_dir}/install-master.sh /usr/bin
        sudo mv easy-linux.desktop /usr/share/applications/easy-linux.desktop
        sudo cp .envrc $scripts_dir && direnv allow
        sudo mv Banner_func.sh install-fix-my-perm.sh install-makeWordlist.sh install-monDOWN.sh install-monUP.sh install-sysinfo.sh install-wifite.sh install-wpaDOWN.sh install-wpaUP.sh linux_connection_script.sh Prompt_func.sh trap-wifi.sh support/
        sudo touch support/adapter
        cd $scripts_dir && direnv allow
        else
            printf "     Invalid selection\\n"
        fi
}

cleanup_func() {
  printf " - Please Wait while I cleanup some files used in the installation - \\n" 
  printf "${WT}..."; slept 1; printf "...Almost done\\n" 
  sudo rm tmp/*.*
  sudo rmdir tmp/
  printf "...done.${CY}"
  clear
  source "support/Banner_func.sh" 
  printf "   ${CY}Beesoc's Easy Linux Loader has been installed.\\n\\n" 
  printf "   Use the option on your ${WT}Apps menu ${CT}or enter [ ${WT}install-master.sh${CT} ]\\n"
  printf "   from ${WT}any Terminal ${CY} to access. Thanks for using ${WT}Beesoc's Easy Loader\\n" 
  printf "\\n\\n  ${CY}Press ${WT}any ${CY}key to exit the installer."
read -r -n1 -s -t 60
  exit 1
}

main() {
clear
source "support/Banner_func.sh"
printf "\\n${OG}                 Welcome to the Installer for Beesoc's Easy Linux.                   ${CY}${NC}\\n" 
printf "\\n${CY}Press ${WT}any ${CY}key to continue.                                 Press ${RED}[ctrl+c] ${CY}to cancel\\n"
#printf "${WT}\\n    ---->"
printf "${WT} \\n"
  read -r -n1 -s -t 60
  cd ~/compiled/ || exit
    if [[ -d "$HOME/compiled/easy-linux" ]]; then  
       printf "  ${CY}Existing Github clone for Beesoc's Easy Linux exists.\\n${CY}"
       printf "       Please Wait, removing tmp clone and installing to ${WT}${scripts_dir}.${CY}"; sleep 1 
       printf "${WT}.."
       sudo rm -Rf $HOME/compiled/  
       sleep 1; printf ".."; sleep 1
    else
       printf "  ${CY}Easy-Linux directory not found.  Creating folder and ${WT}cloning Github${CY} repo."
    fi
    cd $HOME/compiled || exit
    git clone https://github.com/Beesoc/beesoc-menu.git
    sudo mkdir "${scripts_dir}/tmp"
    sudo chown -Rf 1000:0 "${scripts_dir}/tmp"
    sleep 1
      if [[ -d "${scripts_dir}/tmp" ]]; then  
          printf "${CY}done..\\n"
      else 
          printf "${RED} An error has occurred. Exiting tool."
          exit 1
      fi
  
folder_exists_func
install_func  
}

main
cleanup_func
