#!/bin/bash
set -e
scripts_dir=/opt/easy-linux

# netadaptercount - query network adapters and select 1 for monitor mode
 adapter_count=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' | grep -c "wl")
#
clear
source ${scripts_dir}/support/support-Banner_func.sh

if [ "${adapter_count}" -eq 1 ]; then
    adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4, " " $5}')
    printf "  \\n${CY}You have ${WT}$adapter_count ${CY}wireless network adapter.\\n"
else
    # If there are multiple wireless interfaces, prompt the user to select one
    printf "  \\n${CY}You have ${WT}$adapter_count ${CY}wireless network adapters.\\n"
    printf "   \\n" 
    printf "${OG}    Multiple wireless interfaces available.${WT} \\n" 
    printf "${CY}    Please select one: \\n${OG}"
    sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' 2> /dev/null | grep "wl" | nl -nln
    printf "   \\n  ${WT}" 
    read -n 1 -r -p "  Enter the number of the interface you want to use in monitor mode: " selection
    selection=${selection:-1}
    adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' | cut -d' ' -f1 | sed -n "${selection}p")
    printf "\\n  ${OG}You have selected wireless adapter: ${adapter}."
fi