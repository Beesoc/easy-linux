#!/bin/bash
scripts_dir=/opt/easy-linux
#
# Version: 0.0.2
#shellcheck source=${scripts_dir}/.envrc
#shellcheck source="${scripts_dir}/support/support-Prompt_func.sh"
#shellcheck source="${scripts_dir}/support/support-Banner_func.sh"
set -e
#
clear
#
source ${scripts_dir}/.envrc

   if command -v hackingtool >/dev/null 2>&1; then
              sudo hackingtool
           else
              printf "\\n${YW}hackingtool is not installed.  Installing...\\n"
              hacking_tool_func
           fi

  if [ ! -d ${scripts_dir} ]; then
        printf "${RED}   ERROR: ${scripts_dir} is not found.  Please reinstall Easy Linux${NC}"
  fi


printf "${CY}Installing ${WT}Hacking Tool${CY}...${NC}\n"
  if [[ -d ${compiled_dir} ]]; then
        printf " \\n";
          cd ~/compiled || exit
          return 1
  elif [[ ! -d ${compiled_dir} ]]; then
          mkdir ~/compiled 
          cd ~/compiled || exit
  else
       printf "${RED}Invalid Selection"
  fi
  
  
  sudo git clone https://github.com/Z4nzu/hackingtool.git
  cd hackingtool || exit
  sudo pip3 install -r requirements.txt
  source sudo ./install.sh
