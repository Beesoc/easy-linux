#!/bin/bash
# Trap Master
# Version: 0.0.2
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc

if sudo iwconfig 2>/dev/null | grep -q "Mode:Monitor"; then
    # Command to execute when a WiFi adapter is in monitor mode
    printf "${CY}  At least 1 WiFi adapter is ${WT}still in monitor mode${CY}. \\n  [?] "
    read -n 1 -p "Should I reenable Managed mode?" managed 
    managed=${managed:=Y}
    if [[ "$managed" =~ ^[yY]$ ]]; then
        source ${scripts_dir}/support/support-monitor.sh
    elif [[ "$managed" =~ ^[nN]$ ]]; then
        printf "  ${WT}$USER ${OG}has selected to remain in Monitor mode."
        printf "  ${CY}You can toggle Monitor mode On/Off in the Easy Linux Hacking Menu."
        echo
else
    clear
fi

echo
printf "${GN}\\n*********************************** Exiting ************************************\\n"
printf "             ${WT}--  ${GN}Thanks for using Beesoc's Easy Linux Loader  ${WT}--\\n\\n"
printf "           ${CY}Use the icon on your ${WT}Apps menu ${CY}or enter [ ${WT}easy-linux.sh${CY} ]\\n"
printf "                  from ${WT}any Terminal ${CY}to access Easy Linux again. \\n${CY}"
printf "${GN}********************************************************************************${NC}\\n"
echo
