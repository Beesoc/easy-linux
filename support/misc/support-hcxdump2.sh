#!/bin/bash
scripts_dir=/opt/easy-linux
#install and use hcxtools w hashcat and jack
#
set -e
#
trap ${scripts_dir}/support/support-hcxdump2.sh EXIT
source ${scripts_dir}/.envrc
# Version: 0.0.4
#	timeout -v 32s ${scripts_dir}/support/support-hcxdump2.sh
	timeout -v 40s sudo hcxdumptool -i "${adapter}" --do_rcascan 

sleep 1
#clear
printf "    ${OG}Restarting NetworkManager and wpa_supplicant..."
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
