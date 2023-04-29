#!/bin/bash
set -euo pipefail

RED='\e[1;31m'
PURPLE='\e[1;35m'
GN='\e[1;32m'
YW='\e[1;33m'
BL='\e[1;34m'
CY='\e[1;36m'
WT='\e[1;37m'
OG='\e[1;93m'
LB='\e[0;34m'
NC='\e[0m'
#################################################  Begin User Options  #########
#set -e
gotcha_mac="12:B3:F4:47:58:B7"
sniffer_mac="22:22:22:22:22:22"
FuckThatSh1t_mac="33:33:33:33:33:33"
scripts_dir=$HOME/scripts
larry_host=potato
cory_host=updates
mike_host=TODO
backup_dir=/opt/backup

###################################################  End User Options  #########

Prompt_func() {
prompt_symbol=㉿
if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
    prompt_color='\[\033[;94m\]'
    info_color='\[\033[1;31m\]'
        # Skull emoji for root terminal
        prompt_symbol=💀
fi
${GN}┌───(${CY}$USER${prompt_symbol}$HOSTNAME${GN})-[${YW}${PWD}${GN}]
${GN}└──${CY}$ 
}

hostname=$(hostname)
user=$USER
pwnagotchi=""
Banner_func() {
  printf "${WT}\\n
-------------------------------------------------------------------------------${CY}
  ▄████▄╗    ▄████▄╗   ▄████▄╗    ▄████▄╗     ▄███▄╗     ▄███▄╗  ██╗  ▄████▄╗  
  ██═══██╝   ██╔═══╝   ██╔═══╝   ██╔════╝    ██╔══██╗   ██╔══▀╝   ▀╝ ██╔════╝  
  ██████╝    █████╗    █████╗     ▀████▄╗    ██║  ██║   ██║           ▀████▄╗  
  ██═══██    ██╔══╝    ██╔══╝      ╚═══██║   ██║  ██╝   ██║  ▄╗        ╚═══██║ 
  ▀████▀╝    ▀████▀╗   ▀████▀╗    ▀████▀╝     ▀███▀╝     ▀███▀╝       ▀████▀╝  
   ╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝${GN}
  ▄████▄╗   ▄█▄╗    ▄███▄╗ █▄╗   ▄█╗   ▄█╗    ▄█╗ ▄█╗  █▄╗ ▄█╗  ▄█╗ ██▄╗  ▄██╗${GN} 
  ██╔═══╝  ██║██╗  ██╔═══╝  ██╗ ██╔╝   ██║    ██║ ██▄╗ ██║ ██║  ██║  ▀██▄██▀╝ ${GN} 
  █████╗  ███▀███╗  ▀███▄╗   ████╔╝    ██║    ██║ ████▄██║ ██║  ██║    ███║${GN}    
  ██╔══╝  ██║  ██║   ╚══██║   ██╔╝     ██║    ██║ ██║▀███║ ██║  ██║  ▄██▀██▄╗${GN}  
  ▀████▀╝ ██║  ██║  ▀███▀╝    ██║      ▀████╗ ██║ ██║  ██║  ▀███▀╝  ██▀╝  ▀██╗${GN} 
   ╚═══╝  ╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═══╝ ╚═╝ ╚═╝  ╚═╝   ╚═╝    ╚═╝    ╚═╝ ${WT}
------------------------------------------------------------------------------- \\n"
#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
}

sudo su
if [ -d /home/pi ]; then
   sudo chown -vR pi:pi /home/pi/*
fi

if [ -d /opt/backup ]; then
   sudo chown -vR 1000:1000 /opt/backup/*
   sudo chown -vR 1000:1000 /home/1000
#   cd /opt/backup/root
#   sudo chown -vR beesoc:beesoc /opt/backup/root/*.*
#   sudo chown -vR beesoc:beesoc ./.*
fi

if [ -d /home/beesoc ]; then
   sudo chown -vR beesoc:beesoc *
fi



sudo /
