#!/bin/bash
# check for internet
# Version: 0.0.2
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc

   echo -e "${YELLOW}[*] Checking Internet Connection ..${NC}"
    echo "";
    if curl -s -m 10 https://www.google.com > /dev/null || curl -s -m 10 https://www.github.com > /dev/null; then
        echo -e "${GREEN}[✔] Internet connection is OK [✔]${NC}"
        echo "";
        echo -e "${YELLOW}[*] Updating package list ..."
        # Perform installation steps based on the user's choice
        sudo apt update -y && sudo apt upgrade -y
    else
        printf "${RED}  No available Internet or Connection too slow to use"
    fi 