#!/bin/bash
# script to switch wifi adapter between MONITOR and managed mode.
set -e
# Version: 0.0.4
#
clear
scripts_dir=/opt/easy-linux

trap ${scripts_dir}/support/support-trap-wifi.sh EXIT
source ${scripts_dir}/.envrc

change_net_func() {
    sudo systemctl stop NetworkManager && sudo systemctl stop wpa_supplicant

	sudo ifconfig $adapter down
	sudo iw $adapter set type $mode

  if ! command -v macchanger >/dev/null 2&>1; then
      sudo apt install -y macchanger
  elif command -v macchanger >/dev/null 2&>1; then
      if [[ $mode == "monitor" ]]; then
		sudo macchanger -a ${adapter}
	elif [[ $mode == "managed" ]]; then
		sudo macchanger -p ${adapter}
	fi
  fi
	sudo ifconfig $adapter up
	printf "${OG}Starting NetworkManager and wpa_supplicant${OG}."
	sleep 1; printf "3..."; sleep 1; printf "2..."; sleep 1; printf "1..."
	sudo systemctl start NetworkManager
	sudo systemctl start wpa_supplicant
fi
}

main() {
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
adapter=""
sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"

if [[ -e /sys/class/net/wlan0 ]]; then
	if [[ -e /sys/class/net/wlan1 ]]; then
   		 # Run the command for wlan1
  	 	 ${scripts_dir}/support/support-netadapter.sh
	else
   		 printf "Only 1 wifi adapter detected. Selecting wlan0"
   		 adapter=wlan0
   	fi	
elif [[ ! -e /sys/class/net/wlan0 ]]; then
	printf "${RED}  ERROR:${WT}No wifi adapters ${RED}can be seen on your PC at this time.\\n"
	printf "  ${OG}NOTE: At this time, wifi adapters must use the wlan? naming convention.\\n"
      adapter=""
      exit 1
fi

sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
mode=$(iw dev $adapter info | awk '/type/ {print $2}')
		if [[ $mode == "monitor" ]]; then
			printf "${GN}  You are currently in ${WT}$mode Mode${GN} on ${WT}${adapter}${GN}.\\n"
			printf "This mode is for hacking. ${WT}Wifi won't work ${GN}while it's enabled.\\n"
			read -n 1 -p "Do you want to change to the default mode? [Y/n] " choice
			choice=${choice:-Y}
			if [[ $choice == "y" ]] || [[ $choice == "Y" ]]; then
				# Code to change wlan0 back to managed mode
				mode=managed
				change_net_func
				printf "Adapter $adapter changed to $mode mode.\n"
			elif [[ $choice == "n" ]] || [[ $choice == "N" ]]; then
				printf "  ${WT}$USER ${OG}has selected to ${WT}keep their wifi mode the same.${OG}.\n"
			fi
		elif [[ $mode == "managed" ]]; then
			printf "${GN}  You are currently in ${WT}$mode mode${GN} on ${WT}$adapter${GN}.\\n"
			printf "This mode is for accessing the internet. ${WT}Hacking won't work ${GN}while it's enabled.\\n"
			read -n 1 -p "Do you want to change it to monitor mode? [y/N] " choice2
			choice2=${choice2:-N}
			if [[ $choice2 == "y" ]] || [[ $choice2 == "Y" ]]; then
				# Code to change wlan0 to monitor mode
				mode=monitor
				change_net_func
				printf "Adapter $adapter changed to $mode mode.\n"
			elif [[ $choice2 == "n" ]] || [[ $choice2 == "N" ]]; then
				printf "  ${WT}$USER ${OG}has selected to ${WT}keep their wifi mode the same.${OG}.\n"
			else
				printf "  ${RED}Invalid Selection. Valid options are Y or N."
			fi
		fi
}

main

if [ $mode == "managed" ]; then
    sudo systemctl restart NetworkManager
    sudo systemctl restart wpa_supplicant
    sleep 3
fi
