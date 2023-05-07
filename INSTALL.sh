#!/bin/bash
# 
# Installer script for Beesoc's Easy Linux Loader.
#     define colors
# Version: 0.0.2
set -e

scripts_dir=/opt/easy-linux
compiled_dir=/tmp/easy-linux

# Install prereq, DIRENV
           if command -v /usr/bin/direnv >/dev/null 2>&1; then
                printf "${GN}DIRENV is already installed\\n"
           else
                printf "${YW}DIRENV is not installed. Installing\\n"
                direnvinstall=$(curl -sfL https://direnv.net/install.sh | bash)
	         source $direnvinstall
           fi

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
        printf "  ${CY}${scripts_dir}/install not found.\\n${CY}  Please Wait, creating ${WT}${scripts_dir}/install ${CY}directory"; sleep 1 
        printf "${WT}.."; sleep 1; printf "..\\n"; sleep 1
        sudo mkdir ${scripts_dir}/install
  elif [[ -d ${scripts_dir}/install ]]; then 
      printf "${CY}${scripts_dir}/install found. Continuing.\\n"
      sudo chown -Rf 1000:0 ${scripts_dir}/install
      sudo rm -Rf ${scripts_dir}/install/
      sudo mkdir ${scripts_dir}/install
  else 
       printf "     ${RED} Unknown error detected. Exiting.\\n"
       exit 1
  fi  

    sudo chown -Rf 1000:0 ${scripts_dir}
    sudo chown -Rf 1000:0 ${compiled_dir}
}

identity_wiz_func(){
printf "${OG}  Autodetection has failed. I'll now ask you several questions and we'll proceed.${GN}\\n"
read -p "When you login to Linux, is your username, $USER? [Y/n] " userchoice
userchoice=${userchoice:-Y}
if [[ $userchoice =~ ^[Yy]$ ]]; then
  printf "${CY}Continuing...\\n"
  ORIGINAL_USER=$USER
  
else
  read -p "Enter the EXACT username you use to login to Linux. CASE SENSITIVE. " userchoice2
  printf "${OG}You have entered, ${WT}$userchoice2${OG}. Continuing...\\n"
  ORIGINAL_USER=$userchoice2
  echo "export pwnagotchi=$userchoice2" >> $scripts_dir/.envrc 
  exit 0
fi

read -p "Your machine name has been detected as $hostname. Is this correct? [Y/n] " userhost
userhost=${userhost:-Y}
if [[ $userhost =~ ^[Yy]$ ]]; then
  printf "${CY}Continuing...\\n"
  $userhost=$hostname 
else
  read -p "Enter the EXACT computer name you are using. CASE SENSITIVE. " userhost2
  printf "${OG}You have entered, ${WT}$userhost2${OG}. Continuing...\\n"
  hostname=$userchoice2
  echo "export hostname=$userchoice2" >> $scripts_dir/.envrc 
  exit 0
fi

read -p "When you use Easy-Linux, will you be utilizing a Pwnagotchi? [Y/n] " pwnchoice
pwnchoice=${pwnchoice:-Y}
if [[ $pwnchoice =~ ^[Yy]$ ]]; then
  printf "${CY}...\\n"
    read -p "Enter the EXACT name of the Pwnagotchi that you will be using. " pwnchoice2
    pwnagotchi=$pwnchoice2
    echo "export pwnagotchi=$pwnchoice2" >> ${scripts_dir}/.envrc 
elif [[ $pwnchoice =~ ^[Nn]$ ]]; then
  printf "${OG}You have selected that you will ${WT}NOT be using ${OG}a Pwnagotchi. Continuing...\\n"
  unset pwnagotchi
  unset amiPwn
  exit 0
fi

}

define_var_func() {


etc_hostname=$(cat /etc/hostname)
compiled_dir=$HOME/compiled
ORIGINAL_USER=$(cat $USER)
echo "export ORIGINAL_USER=$(cat $USER)" >> ${scripts_dir}/.envrc 


if [ -d /etc/pwnagotchi ] && [ -d /usr/local/share/pwnagotchi ]; then
      amiPwn=yes
      echo "export amiPwn=yes" >> $scripts_dir/.envrc
   elif [ !-d /etc/pwnagotchi ] && [ !-d /usr/local/share/pwnagotchi ]; then
      amiPwn=no
      echo "export amiPwn=no" >> $scripts_dir/.envrc
   else 
      printf "  Unknown error."
fi

if [ $etc_hosts = $hostname ] && [ $ORIGINAL_USER = $home_dir_user ]; then
     if [ $ORIGINAL_USER = beesoc ] && [ $HOST = updates ]; then
         echo "export pwnagotchi=Gotcha" >> $scripts_dir/.envrc
         echo "export hostname=updates" >> $scripts_dir/.envrc
         echo "export ORIGINAL_USER=beesoc" >> $scripts_dir/.envrc
         
      elif [ $ORIGINAL_USER = larry ] && [ $HOST = lepotato ]; then
         echo "export pwnagotchi=Sniffer" >> $scripts_dir/.envrc
         echo "export hostname=lepotato" >> $scripts_dir/.envrc
         echo "export ORIGINAL_USER=larry" >> $scripts_dir/.envrc

      else
         unset pwnagotchi
         echo "export hostname=$etc_hostname" >> $scripts_dir/.envrc
         echo "export ORIGINAL_USER=$USER" >> $scripts_dir/.envrc
         identity_wiz_func
      fi


echo "export etc_hostname=$(cat /etc/hostname)" >> $scripts_dir/.envrc
echo "export compiled_dir=$HOME/compiled" >> $scripts_dir/.envrc

elif [ $etc_hosts != $hostname ] || [ $ORIGINAL_USER != $home_dir_user ]; then
      if [ $etc_hosts != $hostname ]; then
          printf "${RED}    FATAL error: condition check failed. ${WT}$etc_hosts ${CY}should match ${WT}$hostname"
          printf "${OG}    Don\'t Panic! Autodetection has failed. Loading ${WT}manual wizard${CY}."
          identity_wiz_func
elif [ $ORIGINAL_USER != $home_dir_user ]; then
          printf "${RED}    FATAL error: condition check failed. ${WT}$ORIGINAL_USER ${CY}should match ${WT}$home_dir_user"
          printf "${OG}    Don\'t Panic! Autodetection has failed. Loading ${WT}manual wizard${CY}."
          identity_wiz_func
fi
fi         
cd ${scripts_dir} && direnv allow 

}



install_func() { 
clear
    support-Banner_func
    sudo apt install -y bc direnv lm-sensors >/dev/null
define_var_func

printf "${WT}$USER,${CY} "
read -p "do you want to install Easy Linux to ${scripts_dir}? [Y/n] " installchoice
installchoice=${installchoice:-Y}
if [[ $installchoice =~ ^[Yy]$ ]]; then
  printf "${GN}Continuing...\\n"
else
  printf "${RED}Exiting.\\n"
  exit 0
fi

          printf "${CY}Installing to ${WT}${scripts_dir}\\n" 

          sudo cp -Rf ${compiled_dir}/easy-linux/* ${scripts_dir}/
          sudo cp -f ${compiled_dir}/easy-linux/.envrc ${scripts_dir}
          sudo cp -f ${compiled_dir}/easy-linux/.envrc ${scripts_dir}/support
          sudo cp -f ${compiled_dir}/easy-linux/.shellcheckrc ${scripts_dir}
          sudo cp -f ${compiled_dir}/easy-linux/.shellcheckrc ${scripts_dir}/support
          sudo chmod a+x ${scripts_dir}/*.sh
          sudo cp -Rf ${scripts_dir}/install/* ${scripts_dir}

             cd ${scripts_dir} && direnv allow && sudo direnv allow
             cd ${scripts_dir}/support && direnv allow && sudo direnv allow
             cd ${scripts_dir}/install && direnv allow && sudo direnv allow
          source ${scripts_dir}/.envrc
  
              clear
              source ${scripts_dir}/support/support-Banner_func.sh

          sudo chown -vR 1000:0 ${scripts_dir}  
          sudo chmod -R a+x ${scripts_dir}/*.sh
          sudo chmod -R a+x ${scripts_dir}/support/*.sh
            sudo cp -Rf ${scripts_dir}/menu-master.sh /usr/bin
            sudo cp -f ${scripts_dir}/easy-linux.desktop /usr/share/applications
            sudo touch ${scripts_dir}/support/adapter
}

cleanup_func() {

printf "${CY} - Please Wait while I cleanup some files used in the installation -${NC} \\n" 
  printf "${WT}..."; sleep 1; printf "...Almost done\\n" 

if [[ -d ${scripts_dir}/install ]]; then
  sudo rm -Rf ${scripts_dir}/install/
#  sudo rmdir ${scripts_dir}/install/
fi
if [[ -d ${scripts_dir}/INSTALL.sh ]]; then
  sudo rm -Rf ${scripts_dir}/INSTALL.sh
#  sudo rmdir ${scripts_dir}/easy-linux/install/
fi
if [[ -d ${compiled_dir}/beesoc-menu ]]; then
  sudo rm -Rf ${compiled_dir}/beesoc-menu/
#  sudo rmdir ${compiled_dir}/beesoc-menu/
fi
if [[ -d ${compiled_dir}/easy-linux ]]; then
  sudo rm -Rf ${compiled_dir}/easy-linux/
#  sudo rmdir ${compiled_dir}/easy-linux/
fi
if [[ -f $HOME/Downloads/SETUP-easy-linux.sh ]]; then
  sudo rm -f $HOME/Downloads/SETUP-easy-linux.sh
fi
if [[ -f ${scripts_dir}/SETUP-easy-linux.sh ]]; then
  sudo rm -f $scripts_dir/SETUP-easy-linux.sh
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
  printf "${GN}Loading...Please Wait..."
else
  printf "${RED}   Exiting."
  exit 0
fi

folder_exists_func
install_func  
}

main
cd ${scripts_dir} || exit
direnv allow && sudo direnv allow
cd ${scripts_dir}/support || exit
direnv allow && sudo direnv allow
cleanup_func
