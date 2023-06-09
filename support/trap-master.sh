#!/bin/bash
# Trap Master
# Version: 0.0.3
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc

if sudo iwconfig 2>/dev/null | grep -q "Mode:Monitor"; then
    # Command to execute when a WiFi adapter is in monitor mode
    printf "${CY}  Disable Monitor mode in the Easy Linux Hacking menu.\\n"
fi

printf " \\n"
printf "${GN}\\n*********************************** Exiting ************************************\\n"
printf "             ${WT}--  ${GN}Thanks for using Beesoc's Easy Linux Loader  ${WT}--\\n\\n"
printf "           ${CY}Use the icon on your ${WT}Apps menu ${CY}or enter [ ${WT}easy-linux.sh${CY} ]\\n"
printf "                  from ${WT}any Terminal ${CY}to access Easy Linux again. \\n${CY}"
printf "${GN}********************************************************************************${NC}\\n"
echo
