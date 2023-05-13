#!/bin/bash
#
#
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
#
clear
#
source ${scripts_dir}/.envrc

  if [ ! -d ${scripts_dir} ]; then
        printf "${RED}   ERROR: ${scripts_dir} is not found.  Please reinstall Easy Linux${NC}"
  fi

#

install_apps_func() {
clear

options=("All" "Aircrack-NG" "Airgeddon" "Docker Desktop" "Main Menu" "My Favs" "Nano" "TheFatRat" "Hacking Tool" "System Info" "Webmin" "WiFite" "Exit")

source "${scripts_dir}/support/support-Banner_func.sh"
printf "\\n           ${OG}Select which app you would like to install.${GN}\\n\\n" 

select option in "${options[@]}"; do
    case ${option} in

           "Airgeddon")
               clear

                 source ${scripts_dir}/support/support-Banner_func.sh
                 read -p "Do you want to continue? [Y/n] " choiceairged
                 choiceairged=${choiceairged:-Y}
                   if [[ "$choiceairged" =~ ^[Yy]$ ]]; then
                      printf "${GN}  Continuing..."
                   else
                   printf "${RED}  Exiting."
                   exit 0
                   fi

                   source ${scripts_dir}/support/support-airgeddon.sh
          ;;
         "Aircrack-NG")
               clear
                 source ${scripts_dir}/support/support-Banner_func.sh
                   if [[ $(command -v aircrack-ng >/dev/null 2>&1) ]] && [[ $airc-installed = 1 ]]; then
                        printf "${GN}Aircrack-NG is already installed\\n"
                        sudo aircrack-ng --help
                   else
                        printf "${YW}Aircrack-NG is not installed. Installing\\n"
                        source ${scripts_dir}/support/support-aircrack2.sh
                        airc-installed=1
                   fi
           ;;
        "Docker Desktop")

           if [[ $(command -v /opt/docker-desktop/bin/docker-desktop >/dev/null 2>&1) ]] && [[ $docker-installed = 1 ]]; then
                printf "${GN}Docker is already installed\\n"
                sudo /opt/docker-desktop/bin/docker-desktop
           else
                printf "${YW}Docker Desktop is not installed. Installing\\n"
                docker-installed=""
                $docker-installed=1
           fi
         ;;
        "Hacking Tool")
            if [[ $hacktool-inst = 0 ]]; then
               source ${scripts_dir}/support/support-hackingtool.sh
               hacktool-inst=1
            elif [[ $hacktool-inst = 1 ]]; then
               sudo hackingtool
            exit 0
            fi
        ;;
        "TheFatRat")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
                    if [[ $(command -v fatrat >/dev/null 2>&1) ]] && [[ $fatrat-inst = 1  ]]; then
                       printf "\\n${GN}The Fat Rat is already installed"
                    sudo fatrat
                    else
                       source ${scripts_dir}/support/support-fatrat.sh
                    fi
       ;;
        "My Favs")
            if [[ $stan-inst = 0 ]]; then
               source ${scripts_dir}/support/support-inst-standard.sh
               stan-inst=1
            elif [[ $stan-inst = 1 ]]; then
               printf "${OG}  You have already installed all of the standard tools."
            exit 0
            fi
            ;;
        "Main Menu")
            printf "${OG}You selected ${WT}Main Menu\\n${CY}"
            source ${scripts_dir}/menu-master.sh
            ;;
        "Nano")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
            source $scripts_dir/support/support-nano.sh
         ;;
        "System Info")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
            source "${scripts_dir}/support/support-sysinfo.sh"
         ;;
        "Webmin")
            clear
               source "${scripts_dir}/support/support-Banner_func.sh"

               if [[ $(command -v webmin >/dev/null 2>&1) ]] && [[ $webmin_installed = 1 ]]; then
                    printf "${OG}  Webmin already installed. Access via web browser at:\\n${WT} "
                    printf "https://localhost:10000\\n"
                    printf "  ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
                    read n 1 -t 300
               fi
               if [[ $webmin_installed = 0 ]]; then
                  source ${script_dir}/support/support-webmin.sh
                  webmin_installed=1
               fi
        ;;
        "Wifite")
            clear
            source "${scripts_dir}/support/support-Banner_func.sh"
             if [[ $(command -v wifite >/dev/null 2>&1) ]] && [[ $wifite-installed = 1 ]]; then
                        printf "\\n${GN}Wifite is already installed\\n"
                   sudo wifite
                   else
                   printf "\\n${YW}Wifite is not installed\\n"
                   source "${scripts_dir}/support/support-wifite.sh"
                   fi
          ;;
         "All")
              printf "${PL}       You chose ${WT}All.\\n\\n"  
              printf "${PL}   Depending on speed of ${WT}PC and Internet${PL}, this may take a while${YW}\\n  "
              read -n 1 -s -p "Are you sure you want to install All? [Y/n] " all_installed
              all_installed=${all_installed:-Y}
              if [[ $all_installed = "N" ]] || [[ $all_installed = "n" ]]; then
                 printf "${OG}    ${WT}$USER ${OG}has selected to cancel ${WT}'Install All' ${OG}option".
                 exit 0 
              elif [[ $all_installed = "Y" ]] || [[ $all_installed = "y" ]]; then
                # Loop through all options and perform the action
                  for o in "${options[@]:0:12}"; do
                      printf "${OG}Performing action for ${WT}$o${CY}"
                        # Perform action here
                            done
             fi
      break
      ;;
         "Exit")
            clear
            printf "   ${RED}You selected Exit${OG}\\n"
	      		exit 0
            ;;
          *)
            printf "${RED}Invalid option entered.\\n  ${GN}Please try again.\\n${CY}"
            ;;
    esac
done
}



personal_func() {
if [[ $USER = "beesoc" ]] && [[ $HOST = "updates" ]]; then
  source ${scripts_dir}/support/support-updates.sh
else
   exit 0
fi
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
read -n 1 -r installchoice
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
         printf "\\n${GN}Security updates represent 20 percent or less of available updates.  Perform upgrade? [Y/n] "
              read -n 1 -r perfupgrade
              perfupgrade=${perfupgrade:-Y}
                  if [[ $perfupgrade == "n" ]] || [[ $perfupgrade == "N" ]]; then
                      printf "  ${RED}Your system is at severe risk. Updates should be installed soon."
                  elif [[ $perfupgrade == "y" ]] || [[ $perfupgrade == "Y" ]]; then
                      sudo apt upgrade -y
                  fi
      fi
  elif [[ ${installchoice} = "p" ]] || [[ ${installchoice} = "P" ]]; then
      install_apps_func
  fi

FLAG_FILE=/opt/easy-linux/.envrc_populated

if [ ! -f "$FLAG_FILE" ]; then

  # Function to populate .envrc file
  function populate_envrc() {
    # Add more environment variables as needed
#    echo "export MY_VAR=my_value" >> /opt/easy-linux/.envrc
sudo echo "export docker-installed=0" >> ${scripts_dir}/.envrc
sudo echo "export fatrat-installed=0" >> ${scripts_dir}/.envrc
sudo echo "export hacktool-installed=0" >> ${scripts_dir}/.envrc
sudo echo "export hcxdump-installed=0" >> ${scripts_dir}/.envrc
sudo echo "export nano-installed=0" >> ${scripts_dir}/.envrc
sudo echo "export webmin-installed=0" >> ${scripts_dir}/.envrc
sudo echo "export wifite-installed=0" >> ${scripts_dir}/.envrc
sudo echo "export stand-install=0" >> ${scripts_dir}/.envrc 
sudo echo "export amiPwn=0" >> ${scripts_dir}/.envrc
sudo echo "export airc_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export airc__deps_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export airg_deps_inst=0" >> ${scripts_dir}/.envrc
sudo echo "export airg_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export username=$USER" >> ${scripts_dir}/.envrc
sudo echo "export computername=$HOST" >> ${scripts_dir}/.envrc
sudo echo "export hostname=$HOST" >> ${scripts_dir}/.envrc
sudo echo "export arch=$(uname -m)" >> ${scripts_dir}/.envrc
sudo echo "export wordlist=/usr/share/wordlists/Top304Thousand-probable-v2.txt" >> ${scripts_dir}/.envrc

# Populate the envrc table
populate_envrc

# Update flag to indicate function has ran.
touch "$FLAG_FILE"
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
read -n 1 -p "Press M to return to main menu or X to Exit. [M/x]" menuchoice
 menuchoice=${menuchoice:-M}
 if [[  ${menuchoice} = "m" ]] || [[ ${menuchoice} = "M" ]]; then
        source ${scripts_dir}/menu-master.sh
  elif [[  ${menuchoice} = "x" ]] || [[ ${menuchoice} = "X" ]]; then
        printf " \\n";
        exit 0
  else
          printf " ${RED}  Invalid Selection"
fi
}
