#!/bin/bash
# Version: 0.0.2
# check internet speed
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
  printf "${YW}[*] Checking Internet Connection ..${NC}"
    echo "";
    if curl -s -m 10 https://www.google.com > /dev/null || curl -s -m 10 https://www.github.com > /dev/null; then
        echo -e "${GREEN}[✔] Internet connection is OK [✔]${NC}"
        echo "";
        echo -e "${YELLOW}[*] Updating package list ..."
        # Perform installation steps based on the user's choice
     else
        printf "    ${RED}Possible Internet Connection issues have been detected."
