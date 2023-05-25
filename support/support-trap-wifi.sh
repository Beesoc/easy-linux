#!/bin/bash
set -e
# Version: 0.0.3
scripts_dir=/opt/easy-linux
clear
source "${scripts_dir}/.envrc"

# get a list of wireless network interfaces
interfaces=$(iwconfig 2>/dev/null | grep -o "^[^ ]*")

# iterate over the interfaces and check their mode
for iface in $interfaces; do
	mode=$(iwconfig $iface 2>/dev/null | grep -o "Mode:[^ ]*" | cut -f2 -d:)

	if [ "$mode" = "Monitor" ]; then
		# switch the interface to managed mode
		sudo iwconfig $iface mode managed

		# restart wpa_supplicant and Network Manager services
		sudo systemctl restart wpa_supplicant.service NetworkManager.service

		printf "  ${GN}[*] ${CY}Interface ${WT}$iface ${CY}switched to managed mode"
		printf "  ${GN}[*] ${CY}NetworkManager.service and wpa_supplicant.service restarted."
	fi

done
trap "source ${scripts_dir}/support/trap-master.sh" EXIT
