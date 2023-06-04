#!/bin/bash
set -e
# Version: 0.0.3
scripts_dir=/opt/easy-linux
clear
source "${scripts_dir}/.envrc"

# get a list of wireless network interfaces
interfaces=$(iwconfig 2>/dev/null | grep -o "^[^ ]*")

if [ $(iw dev | grep "monitor" -c) -ne 0 ]; then
    printf "  ${CY}You have at least 1 wifi adapter in Monitor mode.${OG}\\n"
    read -n 1 -p "  Do you want to change back to Manage mode? [Y/n] ---->" cngmode
    cngmode=${cngmode:-y}
    printf "\\n${CY}"
    if [ "$cngmode" = "y" ] || [ "$cngmode" = "Y" ]; then
# iterate over the interfaces and check their mode
    for iface in $interfaces; do
    #	mode=$(iwconfig $iface 2>/dev/null | grep -o "Mode:[^ ]*" | cut -f2 -d:)
        mode=$(iw dev | grep "monitor" | cut -f2 -d" ")

          sudo systemctl stop NetworkManager && sudo systemctl stop wpa_supplicant.service
          sudo iw $iface set type managed

	    	# restart wpa_supplicant and Network Manager services
    		sudo systemctl start wpa_supplicant.service && sudo systemctl start NetworkManager.service
            printf "\\n"

    done
       	printf "  ${GN}[*] ${CY}Interfaces ${CY}switched to managed mode.\\n"
	   	printf "  ${GN}[*] ${CY}NetworkManager.service and wpa_supplicant.service restarted.\\n"
    else
       printf " ${WT} $USER ${OG}has selected to stay in Monitor mode.\\n"
       printf " \\n"
  	fi

fi
trap "${scripts_dir}/support/trap-master.sh" EXIT
