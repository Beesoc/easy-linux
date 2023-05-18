#!/bin/bash
# script to switch wifi adapter between MONITOR and managed mode.
set -e
# Version: 0.0.2
#
clear
source ${scripts_dir}/.envrc

change_net_func() {
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
sudo airmon-ng check
sudo airmon-ng check kill
sudo ifconfig $adapter down
sudo iw dev $adapter set type $mode 
if [[ $mode -eq "monitor" ]]; then
  sudo macchanger -a ${adapter}
  elif [[ $mode -eq "managed" ]]; then
  sudo macchanger -p ${adapter}
fi
sudo ifconfig $adapter up
printf "${OG}Starting NetworkManager and wpa_supplicant now to enable ${WT}internet IF ${OG}you have ${WT}MULTIPLE wifi adapters${OG}." && sleep 5 && sudo systemctl start NetworkManager && sudo systemctl start wpa_supplicant
}

main() {

adapter_count=$(sudo airmon-ng | awk '/wl/ {print $2}' | wc -l)
source ${scripts_dir}/support/support-netadapter.sh

if [[ $adapter_count -eq 0 ]]; then
  printf "  ${WT}No wifi adapters ${RED}can be seen on your PC at this time.\\n"
  exit 0
elif [[ $adapter_count -eq 1 ]]; then
  adapter=wlan0
  mode=$(iw dev wlan0 info | awk '/type/ {print $2}')
      if [[ $mode == "monitor" ]]; then
            printf "${GN}  You are currently in ${WT}Monitor Mode${GN} on ${WT}wlan0${GN}.\\n" 
            printf "This mode is for hacking. ${WT}Wifi wont work ${GN}while it's enabled.\\n"
            read -p "Do you want to change it back to managed mode? [Y/n] " choice
            choice=${choice:-Y}
            if [[ $choice == "y" ]] || [[ $choice == "Y" ]]; then
            # Code to change wlan0 back to managed mode
              mode=managed
              change_net_func
              printf "Adapter $adapter changed to $mode mode.\n"
            elif [[ $choice == "n" ]] || [[ $choice == "N" ]]; then     
              printf "  ${WT}$USER ${OG}has selected to ${WT}stay in Monitor mode${OG}.\n"
            fi
       elif [[ $mode == "managed" ]]; then
            printf "${GN}  You are currently in ${WT}Managed Mode${GN} on ${WT}wlan0${GN}.\\n" 
            printf "This mode is for web browsing. ${WT}Hacking wont work ${GN}while it's enabled.\\n"  
            read -p "Do you want to change it to monitor mode? [Y/n] " choice2
            choice2=${choice2:-Y}
            if [[ $choice2 == "y" ]] || [[ $choice2 == "Y" ]]; then
            # Code to change wlan0 to monitor mode
              mode=monitor
              change_net_func
              printf "Adapter $adapter changed to $mode mode.\n"
            elif [[ $choice == "n" ]] || [[ $choice == "N" ]]; then     
              printf "  ${WT}$USER ${OG}has selected to ${WT}remain in Managed mode${OG}.\n"
            else 
                printf "  ${RED}Invalid Selection."
            fi
        fi
elif [[ $adapter_count -ge 2 ]]; then
        for ((i = 0; i < $adapter_count; i++)); do
         adapter="wlan$i"
         mode=$(iw dev "$adapter" info | awk '/type/ {print $2}')
         if [[ $mode == "monitor" ]]; then
                 printf "\\n     ${WT}${adapter} "
                 read -p " is in monitor mode. Do you want to change it back to managed mode? [Y/n] " choice3
                 choice3=${choice3:-Y)
               if [[ $choice3 == "y" ]] || [[ $choice3 == "Y" ]]; then
                 # Code to change wlani to managed mode
                 mode=managed
                 change_net_func
                 printf "${GN}  Adapter ${WT}$adapter ${GN}changed to ${WT}$mode ${GN}mode.\n"
               elif [[ $choice3 == "n" ]] || [[ $choice4 == "N" ]]; then
                 printf "${WT}  $USER ${CY}has selected to ${WT}stay in Monitor mode${CY}."
                # Code to change wlani to monitored mode
                 mode=monitor
                 change_net_func
                 printf "${GN}  Adapter ${WT}$adapter ${GN}changed to ${WT}$mode ${GN}mode.\n"
               fi
        elif [[ $mode == "managed" ]]; then
                 printf "\\n     ${WT}${adapter} "
                 read -p " is in managed mode. Do you want to change to Monitor mode? [Y/n] " choice4
                 choice4=${choice4:-Y)
               if [[ $choice4 == "y" ]] || [[ $choice4 == "Y" ]]; then
                 # Code to change wlani to monitor mode
                 mode=monitor
                 change_net_func
                 printf "${GN}  Adapter ${WT}$adapter ${GN}changed to ${WT}${mode} mode${GN}.\n"
               elif [[ $choice4 == "n" ]] || [[ $choice4 == "N" ]]; then
                 printf "${WT}  $USER ${CY}has selected to ${WT}stay in Managed mode${CY}.\n"
                # Code to change wlani to monitored mode
                 mode=monitor
                 change_net_func
                 printf "${GN}  Adapter ${WT}$adapter ${GN}changed to ${WT}$mode ${GN}mode.\n"
               else
               printf "${RED} Invalid Selection.\n"
               fi
         fi
fi
done
}

main
