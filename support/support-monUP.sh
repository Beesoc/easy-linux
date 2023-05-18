#!/bin/bash
# script to start wifi adapter in MONITOR mode.
set -e
# Version: 0.0.2
#
clear
source ${scripts_dir}/.envrc

select_adapt_func() {
adapterfull=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}')
printf "${LB}"
if [ "${adapter_count}" -eq 1 ]; then
        adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4, " " $5}')
        printf "  \\n${CY}You have ${WT}$adapter_count ${CY}wireless network adapter.\\n"
        return
elif [[ $adapter_count -gt 1 ]]; then
adapter_choice=""
adapter=$(sudo airmon-ng | awk '/wl/ {print $2}')
source ${scripts_dir}/support/support-netadapter.sh
elif [[ $adapter_count -eq 0 ]]; then
    printf "  ${RED}WTF. You need wireless adapters for monitor mode.\\n "
    printf "  NOTE: Wifi devices ${WT}cannot be passed through a Virtual Machine${RED}. Wifi adapters\\n"
    printf "  passed though from a host are identified as Ethernet Adapters. ${WT}Not Compatible${RED}."
    exit 0
fi 
}

execute_func() {
printf "${CY} "
clear
source "${scripts_dir}/support/support-Banner_func.sh"
printf " \\n"
printf "    ${OG}Randomizing MAC address & killing interfering processes \\n" && sudo ifconfig ${adapter} down
sudo macchanger -a ${adapter}
printf "    ${WT}Bringing up monitor mode wifi adapter, ${CY}${adapter}${WT}.\\n${OG} " && adapter_choice=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' | cut -d' ' -f1 | sed -n "${selection}p")
stop_net_func
sudo airmon-ng start ${adapter} && printf "${OG}-\\n"
clear
printf "\\n \\n" && printf "  ${OG}Your MAC address has been changed and your wifi adapter, ${WT}${adapter}${OG}\\n"
printf " is in ${WT}$monitor mode. ${RED}[*!*] ${PL}Happy Hacking ${RED}[*!*]${OG}\\n"
printf " \\n" && printf "  ${OG}When finished, ${RED}return to this menu ${OG}to set everything\\n"
printf "  back to their original values.\\n${NC}\\n"
source ${scripts_dir}/menu-hacking.sh
}

stop_net_func() {
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
sudo airmon-ng check
sudo airmon-ng check kill
}

start_net_func() {
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
clear
}

main() {
adapter_count=$(sudo airmon-ng | awk '/wl/ {print $2}' | wc -l)

if [[ $adapter_count -eq 0 ]]; then
          printf "  ${WT}No wifi adapters ${RED}can be seen on your PC at this time.\\n"
elif [[ $adapter_count -eq 1 ]]; then
          mode=$(iw dev wlan0 info | awk '/type/ {print $2}')
elif [[ $adapter_count -ge 2 ]]; then
          for ((i = 0; i < $adapter_count; i++)); do
              adapter="wlan$i"
              mode=$(iw dev "$adapter" info | awk '/type/ {print $2}')
              printf "Adapter: $adapter, Mode: $mode\n"
          done
else
  printf "  ${RED}Invalid Selection.\\n"
  select_adapt_func
  execute_func
fi

select_adapt_func
execute_func

}
main
source ${scripts_dir}/menu-hacking.sh
