#!/bin/bash
# Network Adapter chooser
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
trap source ${scripts_dir}/support/support-trap-wifi.sh EXIT

# Put this in any script that is calling netadapter.sh
# while true; do
    # Run netadapter.sh
#    ./netadapter.sh

    # Check the exit code of netadapter.sh
#    exit_code=$?

#    if [ $exit_code -eq 0 ]; then
        # netadapter.sh completed successfully
#        break  # Exit the loop
#    else
        # netadapter.sh encountered an error or needs to be restarted
#        echo "netadapter.sh encountered an error or needs to be restarted."
#        echo "Restarting netadapter.sh..."
#    fi
#done

# Put this in any script that is calling netadapter.sh
while true; do
    # Run netadapter.sh
    wlan_sel_func

    # Check the exit code of wlan_sel_func
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        # wlan_sel_func completed successfully
        break  # Exit the loop
    else
        # wlan_sel_func encountered an error or needs to be restarted
        echo "wlan_sel_func encountered an error or needs to be restarted."
        echo "Restarting netadapter.sh..."
    fi
done

wlan_sel_func() {

if [ "$adapter_count" -gt 1 ]; then
    # If there are multiple wireless interfaces, prompt the user to select one
    printf "\\n${CY}You have ${WT}$adapter_count${CY} wireless network adapters.\\n"
    printf "\\n${OG}Multiple wireless interfaces available.${WT}\\n"
    printf "${CY}Please select one:\\n${OG}"

    sudo airmon-ng | awk '/wl/ {print $2 " - " $4 " " $5}' 2>/dev/null | grep "wl" | nl -nln

    printf "\\n${WT}"
    read -n 1 -r -p "Enter the number of the interface you want to use in monitor mode: " selection
    selection=${selection:-1}
    adapter=$(sudo airmon-ng | awk '/wl/ {print $2 " - " $4 " " $5}' | cut -d' ' -f1 | sed -n "${selection}p")

fi
    sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
    printf "\\n${OG}You have selected wireless adapter: $adapter.${NC}\\n"
    sleep 3
    return 0
}

how_many_func() {
	# netadaptercount - query network adapters and select 1 for monitor mode
 if [[ $(command -v airmon-ng) ]]; then	
	#
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
	if [ "${adapter_count}" -eq 1 ]; then
		adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4, " " $5}')
		printf "  \\n${CY}You have ${WT}$adapter_count ${CY}wireless network adapter, $adapter.\\n"
            sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
            sleep 3
            return 0
	elif [[ $adapter_count -gt 1 ]]; then
		adapter_choice=""
		adapter=$(sudo airmon-ng | awk '/wl/ {print $2}')
		wlan_sel_func
	elif [[ $adapter_count -eq 0 ]]; then
		printf "  ${RED}WTF. You need wireless adapters for monitor mode.\\n "
		printf "  NOTE: Wifi devices ${WT}cannot be passed through a Virtual Machine${RED}. Wifi adapters\\n"
		printf "  passed though from a host are identified as Ethernet Adapters. ${WT}Not Compatible${RED}."
		return
	fi
else

  while true; do
    # Run support/support-aircrack2.sh

	printf "  ${WT}Aircrack-NG ${OG}is required to use this script.${WT}\\n  " 
      read -n -r -p "Would you like to install Aircrack-NG now? [Y/n] " aircrack
      aircrack=${aircrack:-Y}

      if [[ "$aircrack" =~ ^[yY]$ ]]; then  

      ${scripts_dir}/support/support-aircrack2.sh
      # Check the exit code of aircrack2.sh

      exit_code=$?
	      if [ $exit_code -eq 0 ]; then
	         # Aircrack2.sh completed successfully
  	       break  # Exit the loop
           else
               # netadapter.sh encountered an error or needs to be restarted
               printf "${OG}  We have encountered an error or need to restart.\\n"
               printf "${OG}    Restarting this script...\\n"
               echo
           fi

      elif [[ "$aircrack" =~ ^[nN]$ ]]; then
  	      printf "${WT}$USER ${RED}has selected to NOT install Aircrack-NG. Exiting.${NC}\n"
  	      exit 0
      else 
            printf "${RED}  Invalid Selection. Options are Y or N only.${NC}\n"
      fi
done
fi

}

main() {

adapter_count=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' | grep -c "wl")
how_many_func

}
main
