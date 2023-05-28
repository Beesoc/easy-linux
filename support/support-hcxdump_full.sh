#!/bin/bash
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
#install and use hcxtools w hashcat and jack
# Version: 0.0.2
set -e
#
trap ${scripts_dir}/support/support-hcxdump.sh EXIT
#	timeout -v 32s ${scripts_dir}/support/support-hcxdump2.sh
timeout -v 600s sudo hcxdumptool -i "${adapter}" -f 0 -f 1 -f 2 -f 4 -f 32 --stop_ap_attacks=600 --resume_ap_attacks=864000d --enable_status=31 --weakcandidate=12345678 --flood_beacon 
  -o ${scripts_dir}/support/misc/hcxdump_full.pcapng

sleep 1
#clear
printf "    ${OG}Restarting NetworkManager and wpa_supplicant..."
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
