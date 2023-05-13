#!/bin/bash
set -e
source ${scripts_dir}/.envrc
# Version: 0.0.2
source ${scripts_dir}/.envrc
    prompt_symbol=㉿
    prompt_color=${GN}
    info_color=${BL}
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
#        prompt_color='\[\033[;94m\]'
        prompt_color=${GN}
        info_color=${RED}
        # Skull emoji for root terminal
        prompt_symbol=💀
    fi

printf "${GN}┌──(${CY}$USER${prompt_symbol}$HOSTNAME${GN})-[${YW}${PWD}${GN}]\\n"
printf "${GN}└─${CY}> ${CY}\\n"
