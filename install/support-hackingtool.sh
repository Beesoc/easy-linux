#!/bin/bash
scripts_dir=/opt/easy-linux
set -e
# Version: 0.0.2
source "${scripts_dir}/.envrc"
clear
            source "${scripts_dir}/support/support-Banner_func.sh"
            printf "${WT}\\n\\        You chose Hacking Tool. ${CY}Download and use the hacking tool featured\\n"
            printf "          in Mr. Robot. This tool has MANY tools built into it.  ${GN}This is a\\n"
            printf "       definite must install. ${WT}Swiss army knife for hackers.\\n\\n    " 

           if [[ $(command -v hackingtool >/dev/null 2>&1) ]]; then
                printf "\\n${GN}Hackingtool is already installed.\\n"
              sudo hackingtool
           else
              printf "\\n${YW}hackingtool is not installed.  Installing...\\n"
           fi

            read -n 1 -p "Do you want to install HackingTool [Y/n] " choicehacking
            choicehacking=${choicehacking:-Y}
            if [[ $choicehacking =~ ^[Yy]$ ]]; then
              printf "${GN}Continuing...\\n"
            else
              printf "${RED}Exiting.\\n"
              exit 0
            fi

  if [[ -d ${compiled_dir} ]]; then
          cd $HOME/compiled || exit
          return 1
  elif [[ ! -d ${compiled_dir} ]]; then
          mkdir $HOME/compiled 
          cd $HOME/compiled || exit
  else
       printf "${RED}Invalid Selection"
  fi
        printf " \\n${CY}"  
  sudo git clone https://github.com/Z4nzu/hackingtool.git
  cd hackingtool || exit
  sudo pip3 install -r requirements.txt
  source ./install.sh
printf "${CY}  Press ${WT}any ${CY}key to continue."
read -n 1 -s -t 300 
source ${scripts_dir}/menu-apps.sh
