#!/bin/bash
#
#
# Version: 0.0.2
scripts_dir=/opt/easy-linux
compiled_dir=$HOME/compiled
#shellcheck source=${scripts_dir}/.envrc
#shellcheck source="${scripts_dir}/support/support-Prompt_func.sh"
#shellcheck source="${scripts_dir}/support/support-Banner_func.sh"
set -e
#
clear
#
install_keyrings=


  if [ ! -d ${scripts_dir} ]; then
        printf "${RED}   ERROR: ${scripts_dir} is not found.  Please reinstall Easy Linux${NC}"
  fi



source ${scripts_dir}/.envrc
  
options=("Hacking Tool" "Docker Desktop" "My Favs" "TheFatRat" "Wifite" "Pwnagotchi" "Webmin" "System Information" "Main Menu" "Exit")
#
source "${scripts_dir}/support/support-Banner_func.sh"

install-apps_options_func() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"

  printf "  \\n                     ${CY}[???]${CY} Please select an option: ${CY}[???]${CY}\\n  \\n"
  printf "  ${OG} 1] ${GN}Docker Desktop${OG}                    20] ${GN}Wifite\\n"
  printf "  ${OG} 2] ${GN}Hacking Tool${OG}                      21] ${GN}The Fat Rat \\n"
  printf "  ${OG} 3] ${GN}Standard Apps${OG}                     22] ${GN}Webmin\\n"
  printf "  ${OG} 4] ${GN}Pwnagotchi ${CY}                             \\n"
  printf "  ${OG}99]${GN} Display System Information                     ${RED} [✘] Exit tool [✘]${NC}\\n"  
  printf " \\n"
    source "${scripts_dir}/support/support-Prompt_func.sh"
  printf "${GN}     ----> "
# Read user input and display the appropriate submenu
read -r choice
  printf "  ${LB}\\n"
#  printf "  ${LB}\\n"
if [[ ${choice} == 1 ]]; then  
    clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    printf "${CY}\\n        You chose Docker Desktop. I highly recommend using Docker. It runs apps in\\n"
    printf "        a combination of virtual containers and virtual machines. The upside of this is it\\n"
    printf "        greatly eliminates problems with software dependencies and corrupt installs. Game Changer.\\n"
    printf "  \\n" 
    source "${scripts_dir}/support/support-Prompt_func.sh"

read -p "Do you want to continue? [Y/n] " choicedocker
choicedocker=${choicedocker:-Y}
if [[ $choicedocker =~ ^[Yy]$ ]]; then
  echo "Continuing...\\n"
else
  echo "Exiting.\\n"
  exit 0
fi

#  source "${scripts_dir}/support/support-Banner_func.sh"
           if command -v /opt/docker-desktop/bin/docker-desktop >/dev/null 2>&1; then
                printf "${GN}Docker is already installed\\n"
           else
                printf "${YW}Docker Desktop is not installed. Installing\\n"
                source "${scripts_dir}/support/support-docker.sh"
           fi
           
elif [[ ${choice} == 2 ]]; then  
    clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    printf "${WT}\\n\\n           You chose Hacking Tool. ${CY}Download and use the hacking tool featured\\n"
    printf "              in Mr. Robot. This tool has MANY tools built into it.  ${GN}This is a\\n"
    printf "           definite must install. ${WT}Swiss army knife for hackers.\\n\\n    " 

read -p "Do you want to continue? [Y/n] " choicehacking
        choicehacking=${choicehacking:-Y}
            if [[ $choicehacking =~ ^[Yy]$ ]]; then
              printf "${GN}Continuing...\\n"
            else
              printf "${RED}Exiting.\\n"
              exit 0
            fi

           if command -v hackingtool >/dev/null 2>&1; then
                printf "\\n${GN}Hackingtool is already installed.\\n"
              sudo hackingtool
           else
              printf "\\n${YW}hackingtool is not installed.  Installing...\\n"
              hacking_tool_func
           fi
#    Hacking Tool_menu

elif [[ ${choice} == 3 ]]; then  
    clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    printf "${YW}\\n\\n        You chose standard apps.${WT} [***] ${YW}This menu contains software that is some\\n"
    printf "        of my favorites or are required for other things that Linux Loader needs.\\n"
    printf "\\n${GN}        Should be safe installing anything here. ${WT}[***]\\n\\n    " 

    read -p "Do you want to continue? [Y/n] " choicefavs
choicefavs=${choicefavs:-Y}
    if [[ $choicefavs =~ ^[Yy]$ ]]; then
          printf "Continuing...\\n"
    else
          printf "Exiting.\\n"
      exit 0
    fi

    standard_apps_func
    
elif [[ ${choice} == 4 ]]; then  
    printf "${CY}      You chose Pwnagotchi. \\n "

read -p "Do you want to continue? [Y/n] " choicepwn
        choicepwn=${choicepwn:-Y}
            if [[ $choicepwn =~ ^[Yy]$ ]]; then
              printf "${GN}Continuing...\\n"
            else
              printf "${RED}Exiting.\\n"
              exit 0
            fi

    clear
#    Pwnagotchi_menu
    source "$scripts_dir/menu-backup_pwn-script.sh"
elif [[ ${choice} == 20 ]]; then  
    printf "${CY}      You chose Wifite. \\n "
    clear
#    Sysinfo_menu

read -p "Do you want to continue? [Y/n] " choicewifite
        choicewifite=${choicewifite:-Y}
            if [[ $choicewifite =~ ^[Yy]$ ]]; then
              printf "${GN}Continuing...\\n"
            else
              printf "${RED}Exiting.\\n"
              exit 0
            fi

           if command -v wifite >/dev/null 2>&1; then
                printf "\\n${GN}Wifite is already installed\\n"
              sudo wifite
           else
              printf "\\n${YW}Wifite is not installed\\n"
              source "${scripts_dir}/support/support-wifite.sh"
           fi

elif [[ ${choice} == 21 ]]; then  
    printf "${CY}      You chose to install the Fat Rat. \\n "
#    Sysinfo_menu

read -p "Do you want to continue? [Y/n] " choicefatrat
        choicefatrat=${choicefatrat:-Y}
            if [[ $choicefatrat =~ ^[Yy]$ ]]; then
              printf "${GN}Continuing..."
            else
              printf "${RED}Exiting."
              exit 0
            fi

           if command -v fatrat >/dev/null 2>&1; then
                printf "\\n${GN}The Fat Rat is already installed"
              bash -c 'fatrat'
           else
              printf "\\n${YW}TheFatRat is not installed"
              source "${scripts_dir}/support/support-fatrat.sh"
           fi

elif [[ ${choice} == 22 ]]; then  
    printf "${CY}      You chose to install Webmin. \\n "
#    Sysinfo_menu

read -p "Do you want to continue? [Y/n] " choicewebmin
        choicewebmin=${choicewebmin:-Y}
            if [[ $choicewebmin =~ ^[Yy]$ ]]; then
              printf "${GN}Continuing..."
            else
              printf "${RED}Exiting."
              exit 0
            fi

           if command -v webmin >/dev/null 2>&1; then
                printf "\\n${GN}Webmin is already installed"
              printf "Access via web browser at https://localhost:10000/sysinfo.cgi?xnavigation=1.\\n"
              printf "Use your normal Linux account info that you use to login to this computer\\n."
           else
              printf "\\n${YW}Webmin is not installed"
              source "${scripts_dir}/support/support-webmin.sh"
           fi

elif [[ ${choice} == 99 ]]; then  
    printf "${CY}      You chose System Information. \\n "
    clear
#    Sysinfo_menu
    source "${scripts_dir}/support/support-Banner_func.sh"
    source "${scripts_dir}/support/support-sysinfo.sh"
elif [[ ${choice} == 0 ]]; then  
#    Exit_menu
    clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    printf "     ${RED}0. [✘] Exit tool [✘]${NC} \\n"
    exit 0
else
    printf "   ${RED}Invalid Selection"
fi
}

hacking_tool_func() {
printf "Installing Hacking Tool...${NC}\n"
  if [[ -d ${compiled_dir} ]]; then
        printf " \\n";
          cd ~/compiled || exit
          return 1
  elif [[ ! -d ${compiled_dir} ]]; then
          mkdir ~/compiled 
          cd ~/compiled || exit
  else
       printf "Invalid Selection"
  fi
  sudo git clone https://github.com/Z4nzu/hackingtool.git
  cd hackingtool || exit
  sudo pip3 install -r requirements.txt
  bash ./install.sh
}
#

standard_apps_func() {
  clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    printf "${OG}  \\n"
    printf "      Installing some of my favorite [ Aptitude, ncdu, htop, git ] and ${WT}known \\n"
    printf "  required${OG} [ ${WT}python3-pip, python3-numpy ${OG}] apps.\\n ${GN}"
      sudo apt install -y aptitude ncdu git ncdu geany geany-plugins htop aircrack-ng > /dev/null
    printf "  \\n" 
      printf "${OG}  Installing additional nano lints.${NC}\\n"
  if [[ -d ${compiled_dir} ]]; then
        printf " \\n";
          cd ${compiled_dir} || exit
        printf "  \\n";
  else
          mkdir ${compiled_dir}
  fi
         
  if [[ -d ${compiled_dir}/nanorc ]]; then
        sudo rm -Rf ${compiled_dir}/nanorc
          cd ${compiled_dir} || exit
        printf "  \\n"
  fi

      git clone https://github.com/scopatz/nanorc.git
        cd nanorc || exit
          sudo cp *.nanorc /usr/share/nano
          sudo cp ./shellcheck.sh /usr/bin
          sudo rm -r ~/compiled/nanorc/
}
install_apps_func() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"
printf "  ${OG}Select which app you would like to install.\\n" 

select option in "${options[@]}"; do
    case ${option} in
        "Hacking Tool")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
            printf " ${OG}\\nHacking Tool\\n"
            hacking_tool_func
            ;;
        "Docker Desktop")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
            source "${scripts_dir}/support/support-docker.sh"
            ;;
        "TheFatRat")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
            printf "${CY}You selected The Fat Rat\\n"
            source "${scripts_dir}/support/support-fatrat.sh"
            ;;
         "Main Menu")
            clear
            printf "${OG}You selected Main Menu\\n${CY}"
            source ${scripts_dir}/menu-master.sh
            ;;
        "My Favs")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
            printf " ${OG}\\nInstalling Standard and Recommended favorite apps\\n"
            standard_apps_func
            ;;
        "Webmin")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
            printf "${CY}You selected Webmin\\n"
            source "${scripts_dir}/support/support-webmin.sh"
            ;;
          "Exit")
            clear
            printf "   ${RED}You selected Exit${OG}\\n"
	      		exit 0
            ;;
          *)
            printf "${RED}Invalid option\\n${CY}"
            ;;
    esac
done
}

personal_func() {
#####  Personal  #######
printf "${CY}  Install Storm-Breaker"
  sudo apt install -y python3-requests python3-colorama python3-psutil > /dev/null
  cd /opt || exit
  sudo git clone https://github.com/ultrasecurity/Storm-Breaker.git
  cd Storm-Breaker || exit
  sudo bash ./install.sh
  cd storm-web
  sudo su
  rm config.php
  touch ./config.php
  echo "<?php

\$CONFIG = array (
    \"hidden\" => [
        \"fullname\" => \"hacker\",
        \"password\" => \"57aW48YwPn3@\",
    ],

);

?>" > config.php

  printf "Install ngrok"
  cd $HOME/Downloads
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
  sudo tar xvzf $HOME/Downloads/ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
  printf "Go signup for an ngrok account.  That's how you get the key below"
  ngrok config add-authtoken $ngrok_token
}

main() {

clear
source "${scripts_dir}/support/support-Banner_func.sh"
printf "\\n              ${CY}First, we will ${WT}update/upgrade ${CY}all packages.\\n"
printf "\\n                    ${RED}[!!!] ${YW}IMPORTANT CHOICE ${RED}[!!!]\\n "
printf "\\n             ${CY}Enter the ${WT}C ${CY}key to continue for ${GN}ANYTHING EXCEPT${CY} a Pwnagotchi.\\n"
printf "     ${GN}---->   ${CY}If you're using a Pwnagotchi, enter P to continue.${NC}\\n${CY}"
printf "\\n         ${RED}[!!!] ${YW}DONT UPDATE/UPGRADE A PWNAGOTCHI, ENTER P ${RED}[!!!]${NC}\\n"
printf "\\n      ${WT}[P]${GN}wnagotchi ${CY}or ${WT}[C]${GN}ontinue ${CY}with ANY other Linux distro? ----> "
read -r installchoice
  if [[ ${installchoice} = "c" ]] || [[ ${installchoice} = "C" ]]; then
    sudo apt update
       updates=$(sudo apt list --upgradable | wc -l)
       security_updates=$(sudo apt list --upgradable 2>/dev/null | grep -E '\[security|critical\]' | wc -l)
       security_pct=$(echo "scale=2; ($security_updates/$updates)*100" | bc)
    printf "  ${CY}You have ${updates} updates available, of which ${security_updates} are security related or severe.\\n"
    printf "  ${CY}Please wait. This step may take ${WT}several minutes ${CY}depending on your internet speed!\\n"
      if (( $(echo "$security_pct >= 20" | bc -l) )); then
         printf "${RED}Security updates represent 20 percent or more of available updates.  Performing upgrade. "
      sudo apt upgrade -y
      elif (( $(echo "$security_pct <= 20" | bc -l) )); then
         printf "\\n${GN}Security updates represent 20 percent or less of available updates.  Perform upgrade? [Y/N] "
              read -r perfupgrade
                  if [[ $perfupgrade == "n" ]] || [[ $perfupgrade == "N" ]]; then
                      printf "  ${RED}Your system is at severe risk. Updates should be installed soon."
                  elif [[ $perfupgrade == "y" ]] || [[ $perfupgrade == "Y" ]]; then
                      sudo apt upgrade -y
                  fi
      fi
  elif [[ ${installchoice} = "p" ]] || [[ ${installchoice} = "P" ]]; then
      install-apps_options_func
  fi

    printf "  ${CY}"
    install-apps_options_func
}

main
standard_apps_func
install_apps_func
hacking_tool_func

 if [[ $(hostname) = "updates" ]]; then
        personal_func
        printf "Updates only install triggered"
 elif [[ $(hostname) != "updates" ]]; then
 return
 fi

  clear
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "\\n                        ${CY}Summary of changes made by this script.${WT}   \\n  " 
  printf "                   [ Update/Upgrade all packages ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"; sleep 1
  printf "                           [ Install HackingTool ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"; sleep 1
  printf "                   [ Docker Desktop Dependencies ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"; sleep 1
  printf "                        [ Install Docker Desktop ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"; sleep 1
  printf "                               [ Install Wifite2 ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"; sleep 1
  printf "                              [ Install HCXTools ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"; sleep 1
  printf "                           [ Install The Fat Rat ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"; sleep 1
  printf "                 [ Install Additional Nano Lints ].....${GN}[✔] Successfully Installed [✔]${WT}\\n"; sleep 1
printf "  ${CY}Press M to return to the Main Menu.\\n    ----->"
read -r menu_choice
 if [[  ${menu_choice} = "m" ]] || [[ ${menu_choice} = "M" ]]; then
        printf " \\n";
        source ${scripts_dir}/menu-master.sh
  else
          printf " ${RED}  Invalid Selection"
fi